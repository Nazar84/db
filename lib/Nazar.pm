package Nazar;
use Mojo::Base 'Mojolicious';

use Nazar::Helper;

# use Nazar::Controller;
# has controller_class =>  'Nazar::Controller';


# This method will run once at server start
sub startup {
  my $self = shift;

  push @{ $self->commands->namespaces }, 'Nazar::Command';

  # Load configuration from hash returned by config file
  my $config = $self->plugin(
  	Config => {file => 'etc/nazar.conf'}
  );

  # Configure the application
  $self->secrets($config->{secrets});

  Nazar::Helper::add_helpers( $self );

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('example#welcome');

  $r->get('/driver'       )->to( 'driver#read_driver'  );
  $r->get('/driver/create')->to( 'driver#create_form');
  $r->get('/driver/create')->to( 'driver#save_form');
  $r->get('/driver/create')->to( 'driver#save_form');
  $r->get('/driver/create')->to( 'driver#save_form');
  $r->get('/driver/create')->to( 'driver#save_form');
  $r->get('/driver/create')->to( 'driver#save_form');

  $r->get ( '/track'               )->to( 'track#list_tracks'    );
  $r->get ( '/track/create'        )->to( 'track#create_form'    );
  $r->post( '/track/create'        )->to( 'track#save_form'      );
  $r->get ( '/track/show/<:id>'    )->to( 'track#show_track'     );
  $r->get ( '/track/edit/<:id>'    )->to( 'track#edit_form'      );
  $r->post( '/track/edit/<:id>'    )->to( 'track#update_form'    );
  $r->get ( '/track/delete/<:id>'  )->to( 'track#delete_track'   );


  $r->get ( '/client'              )->to( 'client#list_clients'  );
  $r->get ( '/client/create'       )->to( 'client#create_form'   );
  $r->post( '/client/create'       )->to( 'client#save_form'     );
  $r->get ( '/client/show/<:id>'   )->to( 'client#show_client'   );
  $r->get ( '/client/edit/<:id>'   )->to( 'client#edit_form'     );
  $r->post( '/client/edit/<:id>'   )->to( 'client#update_form'   );
  $r->get ( '/client/delete/<:id>' )->to( 'client#delete_client' );

  $r->get('/figura')->to( 'example#read_figura' );
  $r->get('/figura/create')->to( 'example#create_figura' );
  warn "APPLICATION READY\n";
}

1;
