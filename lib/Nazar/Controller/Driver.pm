package Nazar::Controller::Driver;
use Mojo::Base 'Mojolicious::Controller';



sub list_driver {
	my( $c ) =  @_;

	my @drivers =  $c->db->resultset( 'Driver' )->all;

	my $result =  '';
	for my $i ( @drivers ) {
		$result .= join ' -- ', $i->id, $i->name, $i->tel, $i->mail;

		$result .= " <a href='/driver/edit/" .$i->id ."'>Edit</a>";
		$result .= " <a href='/driver/delete/" .$i->id ."'>Delete</a>";
		$result .= '<br>';
	}

	$c->render( text => $result );
}



sub create_form {
	my( $c ) =  @_;

	my $form = << "	TEXT";
	<form action="" method="POST">
	<label for="GET-name">Name:</label>
	<input id="GET-name" type="text" name="name">
	<br>

	<form action="" method="POST">
	<label for="GET-name">Tel:</label>
	<input id="GET-name" type="text" name="tel">
	<br>

	<form action="" method="POST">
	<label for="GET-name">Mail:</label>
	<input id="GET-name" type="text" name="mail">
	<input type="submit" value="Save">
	</form>
	TEXT

	$c->render( text => $form );
}



sub save_form {
	my( $c ) = @_;

	my $name = $c->param( 'name' );
	my $tel  = $c->param( 'tel'  );
	my $mail = $c->param( 'mail' );

	my $driver = $c->db->resultset( 'Driver' );
	$driver->create({ name => $name, tel => $tel, mail => $mail });

	$c->render( text => 'Data is saved')
}



sub show_driver {
	my( $c ) = @_;

	my $id = $c->param( 'id' );

	my $driver = $c->db->resultset( 'Driver' )->search({ id => $id })->first;

	my $result .= join '--', $driver->id, $driver->name, $driver->tel, $driver->mail;
	$result .= " <a href='/driver/edit/" .$id ."'>Edit</a>";
	$result .= " <a href='/driver/delete/" .$id ."'>Delete</a>";

	$c->render( text => $result );
}



sub edit_form {
	my( $c ) = @_;

	my $id = $c->param( 'id' );

	my $driver = $c->db->resultset( 'Driver' )->search({ id => $id })->first;

	my $name = $driver->name;
	my $tel  = $driver->tel;
	my $mail = $driver->mail;

	my $form = <<"	TEXT";
	<form action="" method="POST">
	<label for="GET-name">Name:</label>
	<input id="GET-name" type="text" name="name" value="$name">
	<br>

	<form action="" method="POST">
	<label for="GET-name">Tel:</label>
	<input id="GET-name" type="text" name="tel" value="$tel">
	<br>

	<form action="" method="POST">
	<label for="GET-name">Mail:</label>
	<input id="GET-name" type="text" name="mail" value="$mail">
	<input type="submit" value="Save">
	</form>
	TEXT

	$c->render( text => $form );
}



sub update_form {
	my( $c ) = @_;

	my $id   = $c->param( 'id'   );
	my $name = $c->param( 'name' );
	my $tel  = $c->param( 'tel'  );
	my $mail = $c->param( 'mail' );

	my $driver = $c->db->resultset( 'Driver' )->search({ id => $id })->first;

	$driver->update({ name => $name, tel => $tel, mail => $mail });

	$c->render( text => 'Data is updated' );
}


sub delete_driver {
	my( $c ) = @_;

	my $id = $c->param( 'id' );

	my $driver = $c->db->resultset( 'Driver' )->search({ id => $id })->first;
	$driver->delete;

	$c->render( text => 'deleted' );
}



1;
