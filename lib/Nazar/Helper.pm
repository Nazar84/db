package Nazar::Helper;

use Modern::Perl;
use Nazar::Schema;

sub add_helpers {
	my( $app ) =  @_;


	$app->helper( db => \&db_connection );

	$app->helper( model          =>  \&model                          );
	$app->helper( atomic_change  =>  \&start_transaction              );
	$app->helper( resource       =>  \&resource                       );
	$app->helper( 'reply.empty'  =>  \&reply_empty                    );
	$app->helper( 'reply.mfile'  =>  \&reply_mfile                    );

}



## DB
sub start_transaction {	shift->db->txn_scope_guard }

my $schema;
sub db_connection {
	my $c =  shift;
	return $schema   if $schema;

	my $DB =  $c->app->config->{ db }   or return;
	$DB->{ DSN } =  sprintf "dbi:%s:dbname=%s;host=%s;port=%s",  @$DB{ qw/ DRVR NAME HOST PORT / };

	$schema //=  Nazar::Schema->connect( $DB->{ DSN },  @$DB{ qw/ USER PASS / },  {
		AutoCommit => 1,
		RaiseError => 1,
		PrintError => 1,
		ShowErrorStatement => 1,
		# HandleError => sub{ DB::x; 1; },
		# unsafe => 1,
		quote_char => '"',  # Syntax error: SELECT User.id because of reserwed word
	});


	return $schema;
}



sub model {
	my( $c, $table_name ) =  (shift,shift);

	$table_name //=  $c->can( 'rs_class' )?
		# Use special method name
		$c->rs_class:

		# Get table name from last part of the caller package:
		# MaitreD::C::User  ->  User
		((ref $c) =~ /([^:]*)$/)[0];


	my $rs =  $c->db->resultset( $table_name );

	return $rs   if $_[0]  &&  $_[0] eq 'insecure';
	return $c->data_guard( $rs );
}




sub resource {
	my $c =  shift;

	return $c->{ resource }   if $c->{ resource };

	my $id         =  $c->validation->param( 'id' );
	my $app_period =  $c->validation->param( 'app_period' );
	my $data =  { id => $id };
	if( $app_period ) {
		$app_period =  $c->app_period   if $app_period eq 'current';
		$data->{ app_period } =  { '&&' => $app_period };
	}

	# TODO: Improve temporal interface: When into current period fall many
	# different values then here we will work only with 'first' value from
	# 'current' period. But what if user want to work with some other value??
	unless( $id  &&  ($c->{ resource } //=  $c->model->xsearch( $data )->first) ) { #IT
		$id //=  '""';
		$c->stash->{ error }{ message } =  "Requested resource ID:$id not_found";
		$c->reply->empty;

		return undef;
	}


	return $c->{ resource };
}



sub reply_empty {
	my $c =  shift;

	$c->render( status => 204,  data => '' );
}



use Mojo::File();
sub reply_mfile {
	my( $c, $file, $name ) =  @_;
	# Extract $name from path if not provided. Temporary file does not have
	# good name thus we allow $name parameter
	$name // (($name ) =  $file =~ /([^\/]*)$/ );

	$c->res->headers->content_disposition( "attachment; filename=\"$name\"" )
		if !$c->res->headers->content_disposition;

	$c->render( status => 200,  data => Mojo::File::path($file)->slurp );
}


1;
