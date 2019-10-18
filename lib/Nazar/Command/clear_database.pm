package Nazar::Command::clear_database;
use Mojo::Base 'Mojolicious::Command';

use Nazar::Schema;


has description => 'Clear database';
has usage => sub { shift->extract_usage };

# create user app_cleaner with login createdb createrole noinherit password 'password';


sub run {
	my( $self, @args ) =  @_;

	return   unless $args[0]  &&  $args[0] eq '--yes';

	# $self->app->db->storage->dbh->do( ... );
	# We can not drop database we are currently on. Connect to default

	# We do manual connection and do not use 'db' helper
	# becuase we use special user here
	# TODO: Implement parameter to connect with different user
	my $DB  =  $self->app->config->{ db };
	my $dsn =  $DB->{ DSN } =  sprintf "dbi:%s:dbname=postgres;host=%s;port=%s",  @$DB{ qw/ DRVR HOST PORT / };
	my $schema =  Nazar::Schema->connect( $dsn,  @$DB{ qw/ CLEAN_USER CLEAN_PASS / },  {()
		,AutoCommit => 1
		,RaiseError => 1
	});

	$schema->storage->dbh->do( "DROP   DATABASE IF EXISTS $DB->{ NAME }" );
	$schema->storage->dbh->do( "CREATE DATABASE           $DB->{ NAME }" );

	$schema->storage->dbh->do( <<"		SQL" =~ s!^\t\t!  !grm
		DROP ROLE IF EXISTS $DB->{ USER };
		CREATE ROLE $DB->{ USER }
		  NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN
		  PASSWORD '$DB->{ PASS }'
		;
		GRANT create ON DATABASE $DB->{ NAME } TO $DB->{ USER };
		SQL
	);
}

1;


=head1 SYNOPSIS

  Usage: APPLICATION clear_database [OPTIONS]

  Options:
    --yes   Clear database

=cut
