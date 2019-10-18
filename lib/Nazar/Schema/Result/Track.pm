package Nazar::Schema::Result::Track;

use Modern::Perl;
use base 'Nazar::Schema::Result';



my $X =  __PACKAGE__;
$X->table( 'track' );

$X->add_columns(
	id => {
		data_type         =>  'integer',
		is_auto_increment =>  1,
	},
	name => {
		data_type   =>  'text',
		is_nullable => 1,
	},
);

$X->set_primary_key( 'id' );
$X->add_unique_constraint([ 'name' ]);


1;

