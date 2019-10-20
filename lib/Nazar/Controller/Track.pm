package Nazar::Controller::Track;
use Mojo::Base 'Mojolicious::Controller';



sub list_track {
	my( $c ) =  @_;

	my @tracks =  $c->db
		->resultset( 'Track' )
		->all;

	my $result =  '';
	for my $i ( @tracks ) {
		$result .= join ' -- ', $i->id, $i->name;
		$result .= " <a href='/track/edit/" .$i->id ."'>Edit</a>";
		$result .= " <a href='/track/delete/" .$i->id ."'>Delete</a>";
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
	my( $c ) = @_;

	my $name = $c->param( 'name' );

	$c->db->resultset( 'Track' )->create({ name => $name });

	$c->render( text => 'Data saved' );
}



sub show_track {
	my ( $c ) = @_;

	my $id =  $c->param( 'id' );

	my $track =  $c->db->resultset( 'Track' )->search({ id => $id })->first;

	my $result .= join ' -- ', $track->id, $track->name;
	$result .= " <a href='/driver/edit/" .$id ."'>Edit</a>";
	$result .= " <a href='/driver/delete/" .$id ."'>Delete</a>";

	$c->render( text => $result );
}



sub edit_form {
	my( $c ) =  @_;

	my $id =  $c->param( 'id' );
	
	my $track =  $c->db->resultset( 'Track' )->search({ id => $id })->first;

	my $name =  $track->name;

	my $form = <<"	TEXT";
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

	my $id   = $c->param( 'id' );
	my $name = $c->param( 'name' );

	my $track = $c->db->resultset( 'Track' )->search({ id => $id })->first;

	$track->update({ name => $name });

	$c->render( text => 'Data updated' );
}



sub delete_track {
	my( $c ) = @_;

	my $id = $c->param( 'id' );

	my $track = $c->db->resultset( 'Track' )->search({ id => $id })->first;
	$track->delete;

	$c->render( text => 'deleted' );
}



1;
