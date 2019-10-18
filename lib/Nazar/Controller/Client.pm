package Nazar::Controller::Client;
use Mojo::Base 'Mojolicious::Controller';

sub read_client {
	my( $c ) =  @_;

	my @clients =  $c->db
		->resultset( 'Client' )
		->all;

	my $result =  '';
	for my $i ( @clients ) {
		$result .= join ' -- ', $i->id, $i->name;
		$result .= "<a href='/client/edit/" .$i->id ."'>Edit</a>";
		$result .= '<br>';
	}
	$c->render( text => $result );
}



sub delete_client {
	my( $c ) = @_;

	my $id =  $c->param( 'id' );


	my $ds =  $c->db->resultset( 'Client' );

	my $client =  $ds->search({ id => [ $id, $id+1 ] });
	$client->delete;


	$c->render( text => 'OK' );
}




sub create_client {
	my( $c ) =  @_;

	my $ds =  $c->db->resultset( 'Client' );

	my $client =  $ds->create({ 
		name => 'xxxx',
	});

	my $result =  join ' -- ', $client->id, $client->name;

	$c->render( text => $result );
}


sub edit_form {
	my( $c ) =  @_;

	my $id =  $c->param( 'id' );
	my $client =  $c->db->resultset( 'Client' )->search({
		id => $id,
	})->first;

	my $name =  $client->name;
	# my $ddd =  $client->value;

	my $form =  <<"	TEXT";
	<form action="" method="POST">
	  <label for="GET-name">Name:</label>
	  <input id="GET-name" type="text" name="name" value="$name">
	  <input type="submit" value="Save">

	  <label for="GET-name">ddd:</label>
	  <input id="GET-name" type="text" name="x" value="$x">
	  <input type="submit" value="Save">

	  <label for="GET-name">Namddde:</label>
	  <input id="GET-name" type="text" name="y" value="$y">
	  <input type="submit" value="Save">
	</form>
	TEXT

	$c->render( text => $form );
}

sub save_form {
	my( $c ) =  @_;

	my $id =  $c->param( 'id' );
	my $client =  $c->db->resultset( 'Client' )->search({
		id => $id,
	})->first;

	my $name =  $c->param( 'name' );
	# my $name =  $c->param( 'x' );
	# my $name =  $c->param( 'y' );
	$client->update({
		name => $name,
		# x    => $x,
		# y    => $y,
	});


	$c->render( text => 'Data saved' );
}

1;
