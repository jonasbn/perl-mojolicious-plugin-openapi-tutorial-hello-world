#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use Mojo::JSON::Pointer;
use JSON qw();
use Mojo::JSON qw(decode_json encode_json to_json);
use v5.10;

my $json_string = q[{
  "basePath": "/api",
  "definitions": {
    "DefaultResponse": {
      "properties": {
        "errors": {
          "items": {
            "properties": {
              "message": {
                "type": "string"
              },
              "path": {
                "type": "string"
              }
            },
            "required": [
              "message"
            ],
            "type": "object"
          },
          "type": "array"
        }
      },
      "required": [
        "errors"
      ],
      "type": "object"
    },
    "_definitions_DefaultResponse": {
      "properties": {
        "errors": {
          "items": {
            "properties": {
              "message": {
                "type": "string"
              },
              "path": {
                "type": "string"
              }
            },
            "required": [
              "message"
            ],
            "type": "object"
          },
          "type": "array"
        }
      },
      "required": [
        "errors"
      ],
      "type": "object"
    }
  },
  "host": "localhost:3000",
  "info": {
    "title": "Hello World example",
    "version": "1.0"
  },
  "paths": {
    "/hello_world": {
      "get": {
        "operationId": "helloWorld",
        "responses": {
          "200": {
            "description": "Returning string 'hello world'",
            "schema": {
              "properties": {
                "greeting": {
                  "type": "string"
                }
              },
              "type": "object"
            }
          },
          "400": {
            "description": "Default response.",
            "schema": {
              "$ref": "#/definitions/DefaultResponse"
            }
          },
          "401": {
            "description": "Default response.",
            "schema": {
              "$ref": "#/definitions/_definitions_DefaultResponse"
            }
          },
          "404": {
            "description": "Default response.",
            "schema": {
              "$ref": "#/definitions/DefaultResponse"
            }
          },
          "500": {
            "description": "Default response.",
            "schema": {
              "$ref": "#/definitions/DefaultResponse"
            }
          },
          "501": {
            "description": "Default response.",
            "schema": {
              "$ref": "#/definitions/DefaultResponse"
            }
          },
          "default": {
            "description": "Unexpected error",
            "schema": {}
          }
        },
        "summary": "Example app returning hello world",
        "x-mojo-name": "hello_world",
        "x-mojo-to": "example#hello_world"
      }
    }
  },
  "schemes": [
    "http"
  ],
  "swagger": "2.0"
}
];


my $hash = JSON->new->utf8->decode($json_string);

my $pointer = Mojo::JSON::Pointer->new($hash);

my $json = JSON->new->utf8->encode($pointer->data);

print $json;

print JSON->new->utf8->encode($pointer->get('/paths/~1hello_world/get/operationId'));
