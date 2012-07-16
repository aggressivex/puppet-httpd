# Aggressivex puppet module for Httpd (Apache2)

## <span style="color:red">This module is in development process </span>

<span style="color:red">**Don't use for production stage features defined here 
are still missing.**</span>

This module provides an installation of apache and its virtualhosts for CentOS/EL

## Features - in dev process!
    
    - Setup httpd & ensure running.
    - Apache configuration file generator
    - Httpd.conf customizable 100% generated.
    - Possiblity to add Vhost/s 100% customizables.
    - Vhosts files organized on each porject tree.
    - Vhosts batch definition in one hash.

## Basic usage

To install Apache, include module in your puppet file

    include httpd

## Configuration files schema

Both httpd.conf and vhost.conf can be generated using the following schema usign
a puppet hash

Simple string value

    $example = {
        'Listen' => '192.168.1.100:80'
    }

    # Generates
    Listen 192.168.1.100:80

Array value

    $example = {
    'LoadModule' => [
      'auth_basic_module modules/mod_auth_basic.so',
      'auth_digest_module modules/mod_auth_digest.so',
      'authn_file_module modules/mod_authn_file.so',
    ]}

    # Generates
    LoadModule auth_basic_module modules/mod_auth_basic.so
    LoadModule auth_digest_module modules/mod_auth_digest.so
    LoadModule authn_file_module modules/mod_authn_file.so

Hash value

    $example = {
      'ifModule prefork.c' => {
        'StartServers'        => '8',
        'MinSpareServers'     => '5',
        'MaxSpareServers'     => '20',
        'ServerLimit'         => '256',
        'MaxClients'          => '256',
        'MaxRequestsPerChild' => '4000'
      }
    }

    # Generates
    <ifModule prefork.c>
        StartServers 8
        MinSpareServers 5
        MaxSpareServers 20
        ServerLimit 256
        MaxClients 256
        MaxRequestsPerChild 4000
    </ifModule>

A combined example can be sees in manifests/conf.pp that is used as default setup

## Custom httpd.conf
TODO

## VirtualHosts
TODO

## VirtualHosts batch add
TODO

## Conf file generator
TODO

## Copyright and License

Copyright (C) 2012 Aggressivex Networks [MIT LICENSE]

Permission is hereby granted, free of charge, to any person obtaining a copy of 
this software and associated documentation files (the "Software"), to deal in 
the Software without restriction, including without limitation the rights to 
use, copy, modify,merge, publish, distribute, sublicense, and/or sell copies of 
the Software, andto permit persons to whom the Software is furnished to do so, 
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER 
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

### Authors & Contributors

*Pull requests and contributions are welcome.*

- Luis M Hdez <luis.munoz.hdez@gmail.com>

