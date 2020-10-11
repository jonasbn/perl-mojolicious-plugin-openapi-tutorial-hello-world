use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('HelloWorld');
$t->get_ok('/')->status_is(200)->content_like(qr/Mojolicious/i);

$t->get_ok('/api')
  ->status_is(200)
  ->json_is('/basePath', '/api')
  ->json_has('/paths/~1hello_world/get/operationId', 'HelloWorld');

$t->get_ok('/api/hello_world')
  ->status_is(200)
  ->json_is('/greeting', 'Hello World');

done_testing();
