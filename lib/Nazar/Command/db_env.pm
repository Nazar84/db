package Nazar::Command::db_env;
use Mojo::Base 'Mojolicious::Command';

use Nazar::Schema;


has description => 'Shell commands to setup environment for database';
has usage => sub { shift->extract_usage };

# create user App_cleaner with login createdb noinherit password 'password';


sub run {
	my( $self, @args ) =  @_;

	my $DB  =  $self->app->config->{ db };
	$DB->{ DSN } =  sprintf "dbi:%s:dbname=%s;host=%s;port=%s",  @$DB{ qw/ DRVR NAME HOST PORT / };
	print "DB_$_=$DB->{ $_ }\n"   for sort keys %$DB;

	1;
}

1;


=head1 SYNOPSIS

  Usage: APPLICATION db_env [OPTIONS]

  Options:
    NONE

=cut
