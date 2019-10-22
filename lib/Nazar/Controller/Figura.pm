package Nazar::Controller::Figura;
use Mojo::Base 'Mojolicious::Controller';



sub list_figura {
	my( $c ) = @_;

	my @figura = $c->db->resultset( 'Figura' )->all;

	my $result = '';
	for my $i ( @figura ){
		$result .= join ' -- ',
		$i->id, $i->x, $i->y,
		$i->width, $i->height,
		$i->red, $i->green, $i->blue,
		$i->moving, $i->take_point_x, $i->take_point_y;

		$result .= " <a href='/figura/edit/" .$i->id ."'>Edit</a>";
		$result .= " <a href='/figura/delete/" .$i->id ."'>Delete</a>";
		$result .= '<br>';
	}

	$c->render( text=> $result );
}



sub create_form {
	my( $c ) = @_;

	my $form = <<"	TEXT";
	<form action="" method="POST">
	<label for="GET-name">x:</label>
	<input id="GET-name" type="text" name="x">
	<br>

	<form action="" method="POST">
	<label for="GET-name">y:</label>
	<input id="GET-name" type="text" name="y">
	<br>

	<form action="" method="POST">
	<label for="GET-name">width:</label>
	<input id="GET-name" type="text" name="width">
	<br>

	<form action="" method="POST">
	<label for="GET-name">height:</label>
	<input id="GET-name" type="text" name="height">
	<br>

	<form action="" method="POST">
	<label for="GET-name">red:</label>
	<input id="GET-name" type="text" name="red">
	<br>

	<form action="" method="POST">
	<label for="GET-name">green:</label>
	<input id="GET-name" type="text" name="green">
	<br>

	<form action="" method="POST">
	<label for="GET-name">blue:</label>
	<input id="GET-name" type="text" name="blue">
	<br>

	<form action="" method="POST">
	<label for="GET-name">moving:</label>
	<input id="GET-name" type="text" name="moving">
	<br>

	<form action="" method="POST">
	<label for="GET-name">take_point_x:</label>
	<input id="GET-name" type="text" name="take_point_x">
	<br>

	<form action="" method="POST">
	<label for="GET-name">take_point_y:</label>
	<input id="GET-name" type="text" name="take_point_y">
	<input type="submit" value="Save">
	</form>
	TEXT

	$c->render( text => $form );
}



sub save_form {
	my( $c ) = @_;

	my $x            = $c->param( 'x'            );
	my $y            = $c->param( 'y'            );
	my $width        = $c->param( 'width'        );
	my $height       = $c->param( 'height'       );
	my $red          = $c->param( 'red'          );
	my $green        = $c->param( 'green'        );
	my $blue         = $c->param( 'blue'         );
	my $moving       = $c->param( 'moving'       );
	my $take_point_x = $c->param( 'take_point_x' );
	my $take_point_y = $c->param( 'take_point_y' );

	my $figura = $c->db->resultset( 'Figura' );
	$figura->create({
		x            => $x            || 0, 
		y            => $y            || 0,
		width        => $width        || 0,
		height       => $height       || 0,
		red          => $red          || 0,
		green        => $green        || 0,
		blue         => $blue         || 0,
		moving       => $moving       || 0,
		take_point_x => $take_point_x || 0,
		take_point_y => $take_point_y || 0,
	});

	$c->render( text => 'Data is saved' );
}



sub show_figura {
	my( $c ) = @_;

	my $id = $c->param( 'id' );

	my $figura = $c->db->resultset( 'Figura' )->search({ id => $id })->first;

	my $result .= join '--',
		$figura->x, $figura->y,
		$figura->width, $figura->height,
		$figura->red, $figura->green, $figura->blue,
		$figura->moving, $figura->take_point_x, $figura->take_point_y;

	$result .= " <a href='/figura/edit/" .$id ."'>Edit</a>";
	$result .= " <a href='/figura/delete/" .$id ."'>Delete</a>";

	$c->render( text => $result );
}



sub edit_form {
	my( $c ) = @_;

	my $id = $c->param( 'id' );

	my $figura = $c->db->resultset( 'Figura' )->search({ id => $id })->first;

	my $x            = $figura->x;
	my $y            = $figura->y;
	my $width        = $figura->width;
	my $height       = $figura->height;
	my $red          = $figura->red;
	my $green        = $figura->green;
	my $blue         = $figura->blue;
	my $moving       = $figura->moving;
	my $take_point_x = $figura->take_point_x;
	my $take_point_y = $figura->take_point_y;


	my $form = <<"	TEXT";
	<form action="" method="POST">
	<label for="GET-name">x:</label>
	<input id="GET-name" type="text" name="x" value="$x">
	<br>

	<form action="" method="POST">
	<label for="GET-name">y:</label>
	<input id="GET-name" type="text" name="y" value="$y">
	<br>

	<form action="" method="POST">
	<label for="GET-name">width:</label>
	<input id="GET-name" type="text" name="width" value="$width">
	<br>

	<form action="" method="POST">
	<label for="GET-name">height:</label>
	<input id="GET-name" type="text" name="height" value="$height">
	<br>

	<form action="" method="POST">
	<label for="GET-name">red:</label>
	<input id="GET-name" type="text" name="red" value="$red">
	<br>

	<form action="" method="POST">
	<label for="GET-name">green:</label>
	<input id="GET-name" type="text" name="green" value="$green">
	<br>

	<form action="" method="POST">
	<label for="GET-name">blue:</label>
	<input id="GET-name" type="text" name="blue" value="$blue">
	<br>

	<form action="" method="POST">
	<label for="GET-name">moving:</label>
	<input id="GET-name" type="text" name="moving" value="$moving">
	<br>

	<form action="" method="POST">
	<label for="GET-name">take_point_x:</label>
	<input id="GET-name" type="text" name="take_point_x" value="$take_point_x">
	<br>

	<form action="" method="POST">
	<label for="GET-name">take_point_y:</label>
	<input id="GET-name" type="text" name="take_point_y" value="$take_point_y">
	<input type="submit" value="Save">
	</form>
	TEXT

	$c->render( text => $form );
}



sub update_form {
	my( $c ) = @_;

	my $id           = $c->param( 'id'           );
	my $x            = $c->param( 'x'            );
	my $y            = $c->param( 'y'            );
	my $width        = $c->param( 'width'        );
	my $height       = $c->param( 'height'       );
	my $red          = $c->param( 'red'          );
	my $green        = $c->param( 'green'        );
	my $blue         = $c->param( 'blue'         );
	my $moving       = $c->param( 'moving'       );
	my $take_point_x = $c->param( 'take_point_x' );
	my $take_point_y = $c->param( 'take_point_y' );

	my $figura = $c->db->resultset( 'Figura' )->search({ id => $id })->first;

	$figura->update({
		x            => $x            || 0, 
		y            => $y            || 0,
		width        => $width        || 0,
		height       => $height       || 0,
		red          => $red          || 0,
		green        => $green        || 0,
		blue         => $blue         || 0,
		moving       => $moving       || 0,
		take_point_x => $take_point_x || 0,
		take_point_y => $take_point_y || 0,
	});

	$c->render( text => 'Data is updated' );
}



sub delete_figura {
	my( $c ) = @_;

	my $id = $c->param( 'id' );

	my $figura = $c->db->resultset( 'Figura' )->search({ id => $id })->first;
	$figura->delete;

	$c->render( text => 'deleted' );
}

1;
