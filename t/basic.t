use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('HelloWorld');
$t->get_ok('/')->status_is(200)->content_like(qr/Mojolicious/i);

$t->get_ok('/api')
  ->status_is(200)
  ->json_has('/paths')
  ->json_has('200')
  ->json_has('hello_world')
  ->json_has('greeting');

done_testing();
