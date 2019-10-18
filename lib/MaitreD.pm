package MaitreD;
use Mojo::Base 'Mojolicious';

our $VERSION =  'v1.00';

use MaitreD::Validate;
use MaitreD::Helper;

use MaitreD::Controller;
has controller_class =>  'MaitreD::Controller';

use Hash::Merge::Simple;
use MaitreD::Controller::Person;


# This method will run once at server start
sub startup {
	my $app =  shift;

	$app->defaults( layout => 'basic' );
	$app->secrets([ 'MYw3U%tZkm?@' ]);

	# Add another namespace to load commands from
	push @{ $app->commands->namespaces }, 'MaitreD::Command';

	$app->plugin( MergeConfig =>  {
		file => 'etc/' .$app->moniker .'.conf',
		merge => \&Hash::Merge::Simple::merge,
	});
	# default_page is used in redirections. Redirect to site root by default
	$app->config->{ App }{ default_page } //=  'default_page';


	# Enable CORS processing
	my $cors =  $app->config->{ App }{ allow_cors };
	if( $cors  &&  @$cors ) {
		$app->routes->options( '/*path' )->over( headers =>  {
			'Origin'                        =>  qr/\S/ms,
			'Access-Control-Request-Method' =>  qr/\S/ms,
		})->to( cb =>  \&setup_cors_options );
		$app->hook( after_dispatch =>  \&setup_cors );
	}



	MaitreD::Helper::add_helpers( $app );
    MaitreD::Validate::add_validators( $app );

    # TODO: replace by: support@tucha.ua
    $app->plugin( Debug  => { to    => 'kes-kes@yandex.ru' } );
	$app->plugin( Status => { route => $app->routes->any( '/api/status' ) } );
	$app->plugin( Auth => {
		mount       =>  '/api/auth',
		# user_info   =>  'person#info',
		user_info   =>  \&MaitreD::Controller::Person::info,
		auth_user   =>  'person#auth',
		auth_reg    =>  'person#register',
		auth_remind =>  'person#remind_password',
	});
	my $r = $app->routes;
	$r->any( '/static' )->detour( $app );
	$r->add_type( date => qr/\d{4}-\d{2}-\d{2}/ );


	$r->get( '/api/upload_bank_statement' )->to( template => 'bank_statement/upload' )
		->name( 'upload_bank_statement_form' );
	$r->post( '/api/upload_bank_statement' )->to( 'bank_statement#upload' )
		->name( 'upload_bank_statement' );
	$r->get( '/export' )->to( 'export#index' );
	$r->get( '/api/export/:report' )->to( 'export#download' );
	$r->get( '/api/die', sub{
		die "This is error message";
	});



	$app->plugin( OpenAPI3 =>  { schema => 'maitre_d/api-v1.yaml' } );
	$app->plugin('EasyREST');
	$app->plugin('BiTemporal');
	$app->plugin('Chrome');
	$app->plugin('Accounting');
	$app->plugin('ParseDate');


	# Router
	# Remove default namespaces and use only one
	$app->routes->namespaces([ $app->controller_class ]);

	# Inject authorization check for /api/* routes
	my $api =  $r->find( 'api' );
	$api->parent->restrict_access->add_child( $api );

	# FIX: Do not restrict access yet
	# $api->to( required_level => 'user' );
	# $r->find( 'api.schema' )->to( required_level => 'guest' );


	$r->resource( 'countries',  CRUDSEL => [qw/ admin /] );
	$r->resource( 'persons',    CRUDSEL => [qw/ admin /] );
    $r->resource( 'payments',   CRUDSEL => [qw/ admin /] );

    $r->resource( 'orders',     CRUDSEL => [qw/ admin /] );
    $r->get( '/prices' )->to( 'cart#prices' )->name( 'list_prices' );
    $r->get( '/prices/buy/<id:num>' )->to( 'cart#order' )->name( 'make_order' );
    $r->post( '/order/new' )->to( 'cart#order' )->name( 'new_order' );
    $r->get( '/agreement/<id:num>/invoice/<period_id:num>/<docdate:date>' )->to( 'cart#invoice' )->name( 'make_invoice' );
    $r->get( '/agreement/<id:num>/billed_usage/<period_id:num>/<docdate:date>' )->to( 'cart#billed_usage' )->name( 'make_billed_usage' );
    $r->get( '/agreement/<id:num>/billed_usage_actual/<period_id:num>' )->to( 'cart#billed_usage_actual' )->name( 'make_billed_usage_actual' );

    $r->get( '/resources' )->to( 'manager#list_resources' )->name( 'allocated_resources' );

    $r->get ( '/config' )->to( 'order#list_config' )
	    ->name( 'list_config' );
    $r->get ( '/order_with_price' )->to( 'order#list_with_price' )
	    ->name( 'list_order_with_price' );
    $r->get ( '/order_with_change' )->to( 'order#list_config_usage', { changes => 1 } )
	    ->name( 'list_order_with_change' );
    $r->get ( '/config-usage/<id>' )->to( 'order#list_config_usage' )
	    ->name( 'list_config_usage' );
    $r->get ( '/package_detail_ext/<package_id>' )->to( 'order#list_package_detail_ext' )
	    ->name( 'list_package_detail_ext' );

	$r->get ( '/order/<id:num>/details_with_package/<app_period>'
		)->to( 'order_detail#list_with_package' );

	my $mode =  $app->mode;
	warn "\nAPPLICATION STARTED $mode\n\n";
}



sub setup_cors_options {
    my( $c ) =  @_;

    # Only for allowed origins
    my $origin  =  $c->req->headers->origin;
    my $allowed =  $c->config->{ App }{ allow_cors } // [];
    return $c->render( status => 204,  data => '' )
       # Allow CORS in development mode from any requested domain
       unless  $c->app->mode eq 'development'  ||  grep{ $origin eq $_ } @$allowed;

    # Only for existing routes
    my $match  =  Mojolicious::Routes::Match->new( root =>  $c->app->routes );
    my $method  =  $c->req->headers->header( 'Access-Control-Request-Method' );
    my $headers =  $c->req->headers->header( 'Access-Control-Request-Headers' );
    return $c->render( status => 204,  data => '' )
       unless $match->find( $c, { path => $c->req->url,  method => $method } )
       &&  $match->endpoint
    ;


    my $h =  $c->res->headers;
    $h->header( 'Access-Control-Allow-Origin'      =>  $origin        );
    $h->header( 'Access-Control-Allow-Methods'     =>  $method        );
    $h->header( 'Access-Control-Allow-Headers'     =>  'Content-Type, X-Captcha, X-Requested-With' );
    $h->header( 'Access-Control-Allow-Credentials' =>  'true'         );
    $h->header( 'Access-Control-Max-Age'           =>  3600           );

    return $c->render( status => 204,  data => '' );
}



sub setup_cors {
    my( $c ) =  @_;

    # Is this CORS request?
    return   unless  my $origin  =  $c->req->headers->origin;

    # Allow CORS in development mode from any requested domain
    my $allowed =  $c->config->{ App }{ allow_cors } // [];
    return   unless $c->app->mode eq 'development'  ||  grep{ $origin eq $_ } @$allowed;

    my $h =  $c->res->headers;
    $h->header( 'Access-Control-Allow-Headers'     =>  'Content-Type, X-Captcha, X-Requested-With' );
    $h->header( 'Access-Control-Expose-Headers'    =>  'X-Captcha' );
    $h->header( 'Access-Control-Allow-Origin'      =>  $origin );
    $h->header( 'Access-Control-Allow-Credentials' =>  'true'  );
}


1;
