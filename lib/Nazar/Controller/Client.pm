package Nazar::Controller::Client;
use Mojo::Base 'Mojolicious::Controller';

sub list_clients {
	my( $c ) =  @_;

	my @clients =  $c->db
		->resultset( 'Client' )
		->all;

	my $result =  '';
	for my $i ( @clients ) {
		$result .= join ' -- ', $i->id, $i->name;
		$result .= " <a href='/client/edit/" .$i->id ."'>Edit</a>";
		$result .= " <a href='/client/delete/" .$i->id ."'>Delete</a>";
		$result .= '<br>';
	}
	$c->render( text => $result );
}



sub create_form {
	my( $c ) =  @_;

	my $form =  <<"	TEXT";
	<form action="" method="POST">
	<label for="GET-name">Name:</label>
	<input id="GET-name" type="text" name="name">
	<input type="submit" value="Save">
	</form>
	TEXT

	$c->render( text => $form );
}



sub save_form {
	my( $c ) =  @_;

	my $name =  $c->param( 'name' );
	# my $name =  $c->param( 'x' );
	# my $name =  $c->param( 'y' );
	$c->db->resultset( 'Client' )->create({
		name => $name,
		# x    => $x,
		# y    => $y,
	});

	$c->render( text => 'Data saved' );
}



sub show_client {
	my ( $c ) = @_;

	my $id =  $c->param( 'id' );

	my $client =  $c->db
		->resultset( 'Client' )
		->search({ id => $id });
	# [ ....... ]


	$client =  $client->first;
	# [0]

	my $result .= join ' -- ', $client->id, $client->name;

	$c->render( text => $result );
}



sub edit_form {
	my( $c ) =  @_;

	my $id =  $c->param( 'id' );
	my $client =  $c->db
		->resultset( 'Client' )
		->search({id => $id,})
		->first;

	my $name =  $client->name;

	my $form =  <<"	TEXT";
	<form action="" method="POST">
	<label for="GET-name">Name:</label>
	<input id="GET-name" type="text" name="name" value="$name">
	<input type="submit" value="Save">
	</form>
	TEXT

	$c->render( text => $form );
}



sub update_form {
	my( $c ) =  @_;

	my $id =  $c->param( 'id' );
	my $client =  $c->db->resultset( 'Client' )->search({
		id => $id,
	})->first;

	my $name =  $c->param( 'name' );

	$client->update({
		name => $name,
	});

	$c->render( text => 'Data updated' );
}



sub delete_client {
	my( $c ) = @_;

	my $id =  $c->param( 'id' );

	my $ds =  $c->db->resultset( 'Client' );

	my $client =  $ds->search({ id => [ split ',', $id ] }); #({ id => [ $id, $id+1 ] });
	$client->delete;



	$c->render( text => 'OK' );
}



1;

__END__

<body>
<div> .... </div>
<div> .... </div>
<div>
	<p> ... </p>
	<p> ... </p>
	<p>skdfjsldfj <img sdfsdfsdf></img> </p>
</div>
</body>
