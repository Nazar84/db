package Nazar::Controller::Example;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub welcome {
  my $self = shift;

  # Render template "example/welcome.html.ep" with message
  $self->render(msg => 'Welcome to the Mojolicious real-time web framework!');
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
