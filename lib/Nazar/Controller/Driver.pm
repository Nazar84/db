package Nazar::Controller::Driver;
use Mojo::Base 'Mojolicious::Controller';

sub read_driver {
	my( $c ) =  @_;

	my @drivers =  $c->db
		->resultset( 'Driver' )
		# ->search({ id => 5 })
		#->search({}, { order_by => [ 'name' ] } )
		->all;

	my $result =  '';
	for my $i ( @drivers ) {
		$result .= join ' -- ', $i->id, $i->name, $i->tel, $i->mail;
		$result .= '<br>';
		#    $i->update({ name => 'xxxx' })
		# }
	}

	$c->render( text => $result );
}



sub delete_driver {
	my( $c ) = @_;

	my @drivers = $c->db
	->resultset( 'Driver' )
	->all;

	my $result =  '';
	for my $i ( @drivers ) {

		$result .= join ' -- ', $i->id, $i->name, $i->tel, $i->mail;
		$result .= '<br>';

		if( $i->id eq '0' ) {
			$i->delete;
		}
	}
	$c->render( text => $result );
}



sub create_form {
	my( $c ) =  @_;

	my $ds =  $c->db
	->resultset( 'Driver' );
	$ds->create({ 
		id   => '0',
		name => 'xxxx',
		tel  => '0xxxxxxx',
		mail => 'xxxx@yandex.ru',
	});

	my @drivers = $c->db
	->resultset( 'Driver' )
	->all;

	my $result =  '';
	for my $i ( @drivers ) {

		$result .= join ' -- ', $i->id, $i->name, $i->tel, $i->mail;
		$result .= '<br>';
	}

	$c->render( text => $result );
}



sub edit_form {
	my( $c ) =  @_;

	my $id =  $c->param( 'id' );
	my $driver =  $c->db
		->resultset( 'Driver' )
		->search({id => $id,})
		->first;

	my $name = $driver->name;
	my $tel  = $driver->tel;
	my $mail = $driver->mail;

	my $form =  <<"	TEXT";
	<form action="" method="POST">
	<label for="GET-name">Name:</label>
	<input id="GET-name" type="text" name="name" value="$name"0>
	<input type="submit" value="Save">

	  <br>
	  <label for="GET-name">Tel:</label>
	  <input id="GET-name" type="text" name="x" value="$tel">
	  <input type="submit" value="Save">

	  <br>
	  <label for="GET-name">Mail:</label>
	  <input id="GET-name" type="text" name="y" value="$mail">
	  <input type="submit" value="Save">
	</form>
	TEXT

	$c->render( text => $form );
}


1;
