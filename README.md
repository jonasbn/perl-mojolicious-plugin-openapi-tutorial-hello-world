# Tutorial on Mojolicious::Plugin::OpenAPI

I have always wanted to get my hands _dirty_ with **Swagger**. I recently fell over [Mojolicious::Plugin::OpenAPI](https://metacpan.org/pod/Mojolicious::Plugin::OpenAPI), which fits into my _boring stack_ and I decided to do a prototype.

I followed the [tutorial](https://metacpan.org/pod/Mojolicious::Plugin::OpenAPI::Guides::Tutorial) for Mojolicious::Plugin::OpenAPI and found it a bit confusing, so I decided to write up a more simple tutorial.

This tutorial requires that you have [Mojolicious](https://metacpan.org/pod/Mojolicious) installed and recommends [carton](https://metacpan.org/pod/distribution/Carton/script/carton). The installation of these components is however beyond the scope of this tutorial.

**OpenAPI** comes from **Swagger**, which I have had a look at, much water has run under that bridge, so now it is time to look at **OpenAPI** a specification on how to write RESTful APIs in a standardised format.

Here goes, lets start with a basic `hello world` example, [all files are available on GitHub](https://github.com/jonasbn/perl-mojolicious-plugin-openapi-tutorial).

## Hello World

First we set up an application, yes we could do a **Mojolicious** lite-app, but I primarily use **Mojolicious** apps, so I think it makes sense to keep stick to this for reference.

```bash
$ mojo generate app HelloWorld
```

Jump into our newly generated application directory

```bash
$ cd hello_world
```

We then install the plugin we need to enable **OpenAPI** in our **Mojolicious** application

Using **CPAN** shell:

```bash
$ perl -MCPAN -e shell install Mojolicious::Plugin::OpenAPI
```

Using `cpanm`:

```bash
$ cpanm Mojolicious::Plugin::OpenAPI
```

If you need help installing please refer to [the CPAN installation guide](https://www.cpan.org/modules/INSTALL.html).

Create a definition JSON file based on **OpenAPI** to support an Hello World implementation based on the **OpenAPI** specification:

```bash
$ touch openapi.conf
```

The exact name of this file is insignifcant, I just prefer to have clear and understandable filenames for easy identification.

Open `openapi.conf` and insert the following _snippet_:

```json
{
    "swagger": "2.0",
    "info": { "version": "1.0", "title": "Hello World example" },
    "basePath": "/api",
    "paths": {
      "/hello_world": {
        "get": {
          "operationId": "helloWorld",
          "x-mojo-name": "hello_world",
          "x-mojo-to": "example#hello_world",
          "summary": "Example app returning hello world",
          "responses": {
            "200": {
              "description": "Returning string 'hello world'",
              "schema": {
                "type": "object",
                "properties": {
                    "greeting": {
                        "type": "string"
                    }
                }
              }
            },
            "default": {
              "description": "Unexpected error",
              "schema": {}
            }
          }
        }
      }
    }
}
```

Now lets go over our definiton.

- `basePath`: defines the root of our URL, so we would be able to access our application at `/api`, recommendations on versioning APIs using this part is do exist, but for our example application, this is out of scope.

- `paths`: here we define our first API path, so our Hello World application can be accessed at: `/api/hello_world`

- `operationId`: the is an operation identifier, it is important for the OpenAPI part, whereas the two following definitions are mappings of the same operation identifier towards the **Mojolicious** application

- `x-mojo-name`: this is the name used to identify our operation in the **Mojolicious** application

- `x-mojo-to`: this is the specification for the route to be used for our operation in the **Mojolicious** application, more on this later

- `responses`: here we define the type we want to handle, for now we settle for `200`. The response definition outline our response, this could be boiled down to a `string` instead of an `object`, with properties, but the example would be come _too simple_ and in my opinion we work primarily with objects over basic types, so this extended example makes for a better reference.

Next step is to enable the [MetaCPAN: Mojolicious::Plugin::OpenAPI](https://metacpan.org/pod/Mojolicious::Plugin::OpenAPI) plugin in the application

Open the file: `lib/HelloWorld.pm` and add the following snippet:

```perl
$self->plugin("OpenAPI" => {url => $self->home->rel_file("openapi.json")});
```

Note the pointer to our previously created file: `openapi.json`.

The complete file should look like the following:

```perl
package HelloWorld;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  $self->plugin('OpenAPI' => {url => $self->home->rel_file('openapi.json')});

  # Load configuration from hash returned by "my_app.conf"
  my $config = $self->plugin('Config');

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer') if $config->{perldoc};

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('example#welcome');
}

1;
```

Then we add the acual operation, open the file: `lib/HelloWorld/Controller/Example.pm` and add the following snippet:

```perl
sub hello_world {
    my $c = shift->openapi->valid_input or return;

    my $output = { greeting => 'Hello World' };
    $c->render(openapi => $output);
}
```

Note that this maps to the definition in our API definition: `openapi.conf`

```json
"x-mojo-to": "example#hello_world",
```

The complete file should look like the following:

```perl
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
```

I decided to implement the tutorial in a scaffolded application, you could create your own controller, but changing an existing controller this way demonstrates how our newly added OpenAPI API end-point, can live in unison with existing and additional end-points.

Now start the application

```bash
$ morbo script/hello_world
```

And finally - lets call the API

```bash
$ http http://localhost:3000/api/hello_world
```

We should now get the result

```json
HTTP/1.1 200 OK
Content-Length: 26
Content-Type: application/json;charset=UTF-8
Date: Thu, 26 Jul 2018 08:20:59 GMT
Server: Mojolicious (Perl)

{
    "greeting": "Hello World"
}
```

Yay! and our first **Mojolicious** **OpenAPI** implementation works!

In addition to the operation, you can obtain the specification by calling the following URL: `/api`

```bash
$ http http://localhost:3000/api/
```

And as mentioned earlier our existing operations and parts of the application still works as expected, try calling the URL: `/`

```bash
$ http http://localhost:3000/
```

That is it for now, good luck with experimenting with **Mojolicious** **OpenAPI** integration and **OpenAPI**. Thanks to Jan Henning Thorsen ([@jhthorsen](https://twitter.com/jhthorsen)) for the implementation of Mojolicious::Plugin::OpenAPI.

## References:

- [MetaCPAN: Mojolicious::Plugin::OpenAPI](https://metacpan.org/pod/Mojolicious::Plugin::OpenAPI)
- [MetaCPAN: Mojolicious::Plugin::OpenAPI Tutorial](https://metacpan.org/pod/Mojolicious::Plugin::OpenAPI::Guides::Tutorial)
- [OpenAPI Website](https://www.openapis.org/)
- [GitHub repository for tutorial](https://github.com/jonasbn/perl-mojolicious-plugin-openapi-tutorial)
