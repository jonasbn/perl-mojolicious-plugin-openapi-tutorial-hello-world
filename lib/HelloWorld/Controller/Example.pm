package HelloWorld::Controller::Example;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub welcome {
  my $self = shift;

  # Render template "example/welcome.html.ep" with message
  $self->render(msg => 'Welcome to the Mojolicious real-time web framework!');
}

sub hello_world {
    my $c = shift->openapi->valid_input or return;

    my $output = { greeting => 'Hello World' };
    $c->render(openapi => $output);
}

1;
