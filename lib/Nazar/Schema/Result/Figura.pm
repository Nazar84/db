package Nazar::Schema::Result::Figura;

use Modern::Perl;
use base 'Nazar::Schema::Result';



my $X =  __PACKAGE__;
$X->table( 'figura' );

$X->add_columns(
	id => {
		data_type         =>  'integer',
		is_auto_increment =>  1,
	},
	x => {
		data_type   =>  'integer',
		is_nullable => 1,
	},
	y => {
		data_type   =>  'integer',
		is_nullable => 1,
	},
	width => {
		data_type   =>  'integer',
		is_nullable => 1,
	},
	height => {
		data_type   =>  'integer',
		is_nullable => 1,
	},
	red => {
		data_type   =>  'integer',
		is_nullable => 1,
	},
	green => {
		data_type   =>  'integer',
		is_nullable => 1,
	},
	blue => {
		data_type   =>  'integer',
		is_nullable => 1,
	},
	moving => {
		data_type   =>  'integer',
		is_nullable => 1,
	},
	take_point_x    => {
		data_type   =>  'integer',
		is_nullable => 1,
	},	
	take_point_y    => {
		data_type   =>  'integer',
		is_nullable => 1,
	},

);

$X->set_primary_key( 'id' );

1;

