# Class: vhost
#
#
define httpd::vhost::add (
    $ip        = $::ipaddress,
    $port      = '80',
    $project   = 'default',
    $host      = "$::hostname.dev",
    $extraPath = '',
    $setupMode = '',
    $vhost     = false,
    $dirs      = false,
    $setup     = false,
  ) {

  $default_vhost = {
    'DocumentRoot' => "/var/www/vhosts/$project/$host/httpdocs/$extraPath",
    'ServerName'   => "$host",
    'ServerAlias'  => "www.$host",
    'ErrorLog'     => "/var/www/vhosts/$project/$host/logs/error_log",
    'TransferLog'  => "/var/www/vhosts/$project/$host/logs/access_log",
    "Directory /var/www/vhosts/$project/$host/httpdocs/" => {
      'AllowOverride' => 'All',
      'Order'         => 'allow,deny',
      'Allow'         => 'from all'
    }
  }

  $final_vhost = $default_vhost

  if ! defined(File["/var/www/vhosts/$project"]) {
    file { "/var/www/vhosts/$project":
      ensure => "directory"
    }
  }

  $default_dirs = [
    "/var/www/vhosts/$project/$host",
    "/var/www/vhosts/$project/$host/httpdocs",
    "/var/www/vhosts/$project/$host/conf",
    "/var/www/vhosts/$project/$host/conf/httpd",
    "/var/www/vhosts/$project/$host/logs",
  ]

  $final_dirs = $default_dirs

  $default_setup = {
    'includer' => '/etc/httpd/conf.d/vhosts.conf',
    'include'  => "/var/www/vhosts/$project/$host/conf/httpd/*",
    'template' => 'httpd/vhost.auto.erb'
  }

  $final_setup = $default_setup

  file { $final_dirs:
    ensure => "directory"
  }

  file { "httpd_vhost_add_file_${host}":
    path    => "/var/www/vhosts/$project/$host/conf/httpd/vhost.conf",
    mode    => 644,
    content => template($final_setup['template']),
    require => Package['httpd'],
    notify  => Service['httpd'],
  }

  host { $host: ip => $ip,}

  $include = $default_setup['include']
  $includer = $default_setup['includer']

  httpd::conf::line { "httpd_vhost_add_include${host}":
    file => $includer,
    line => "Include $include",
    require => File['httpd_conf_directory'],
    notify  => Service['httpd'],
  }
}