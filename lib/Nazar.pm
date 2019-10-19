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
  $r->get('/driver')->to( 'example#read_driver' );
  $r->get('/driver/create')->to( 'example#create_driver' );
  $r->get('/driver/delete')->to( 'example#delete_driver' );
  $r->get('/track')->to( 'example#read_track' );
  $r->get('/track/create')->to( 'example#create_track' );
  $r->get('/track/delete')->to( 'example#delete_track' );
  $r->get('/client')->to( 'client#read_client' );
  $r->get ('/client/edit/<:id>')->to( 'client#edit_form' );
  $r->post('/client/edit/<:id>')->to( 'client#save_form' );
  $r->get('/client/create')->to( 'client#create_client' );
  $r->get('/client/delete/<:id>')->to( 'client#delete_client' );

  $r->get ( '/client'              )->to( 'client#list_clients'  );
  $r->get ( '/client/create'       )->to( 'client#create_form'  );
  $r->post( '/client/create'       )->to( 'client#save_form'    );
  $r->get ( '/client/show/<:id>'   )->to( 'client#show_client'  );
  $r->get ( '/client/edit/<:id>'   )->to( 'client#edit_form'    );
  $r->post( '/client/edit/<:id>'   )->to( 'client#update_form'  );
  $r->get ( '/client/delete/<:id>' )->to( 'client#delete_client');

  $r->get('/figura')->to( 'example#read_figura' );
  $r->get('/figura/create')->to( 'example#create_figura' );
  warn "APPLICATION READY\n";
}

1;
