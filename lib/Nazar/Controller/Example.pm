package Nazar::Controller::Example;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub welcome {
  my $self = shift;

  # Render template "example/welcome.html.ep" with message
  $self->render(msg => 'Welcome to the Mojolicious real-time web framework!');
}

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



sub create_driver {
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



sub read_track {
	my( $c ) =  @_;

	my @tracks =  $c->db
		->resultset( 'Track' )
		->all;

	my $result =  '';
	for my $i ( @tracks ) {
		$result .= join ' -- ', $i->id, $i->name;
		$result .= '<br>';
}

	$c->render( text => $result );
}



sub delete_track {
	my( $c ) = @_;

	my @tracks = $c->db
	->resultset( 'Track' )
	->all;

	my $result =  '';
	for my $i ( @tracks ) {

		$result .= join ' -- ', $i->id, $i->name;
		$result .= '<br>';

		if( $i->id eq '0' ) {
			$i->delete;
		}
	}
	$c->render( text => $result );
}



sub create_track {
	my( $c ) =  @_;

	my $ds =  $c->db
	->resultset( 'Track' );

	$ds->create({ 
		id   => '0',
		name => 'xxxx',
	});

	my @tracks = $c->db
	->resultset( 'Track' )
	->all;

	my $result =  '';
	for my $i ( @tracks ) {

		$result .= join ' -- ', $i->id, $i->name;
		$result .= '<br>';
	}

	$c->render( text => $result );
}


sub read_client {
	my( $c ) =  @_;

	my @clients =  $c->db
		->resultset( 'Client' )
		->all;

	my $result =  '';
	for my $i ( @clients ) {
		$result .= join ' -- ', $i->id, $i->name;
		$result .= '<br>';
	}
	$c->render( text => $result );
}



sub delete_client {
	my( $c ) = @_;

	my @clients = $c->db
	->resultset( 'Client' )
	->all;

	for my $i ( @clients ) {

		if( $i->id eq '0' ) {
			$i->delete;
		}
	}

	my @clients_read =  $c->db
	->resultset( 'Client' )
	->all;
	
	my $result =  '';

	for my $i ( @clients_read ) {

		$result .= join ' -- ', $i->id, $i->name;
		$result .= '<br>';
	}
	$c->render( text => $result );
}




sub create_client {
	my( $c ) =  @_;

	my $ds =  $c->db
	->resultset( 'Client' );

	$ds->create({ 
		id   => '0',
		name => 'xxxx',
	});

	my @clients = $c->db
	->resultset( 'Client' )
	->all;

	my $result =  '';
	for my $i ( @clients ) {

		$result .= join ' -- ', $i->id, $i->name;
		$result .= '<br>';
	}

	$c->render( text => $result );
}



sub read_figura {
	my( $c ) =  @_;

	my @figures =  $c->db
		->resultset( 'Figura' )
		->all;

	my $result =  '';
	for my $i ( @figures ) {
		$result .= join ' -- ', $i->id, $i->x, $i->y, $i->width, $i->height,
		$i->red, $i->green, $i->blue, $i->moving, $i->take_point_x, $i->take_point_y;
		$result .= '<br>';

	if( $i->id eq '0'){
		$i->delete;
	}
}

	$c->render( text => $result );
}



sub create_figura {
	my( $c ) =  @_;

	my $ds =  $c->db
	->resultset( 'Figura' );

	$ds->create({ 
		id     => '0',
		x      => '000',
		y      => '000',
		width  => '000',
		height => '000',
	});

	$c->render( text => 'create' );
}


1;