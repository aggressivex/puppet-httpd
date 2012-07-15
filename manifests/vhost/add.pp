# Class: vhost
#
#
define httpd::vhost::add (
    $ip        = $::ipaddress,
    $port      = '80',
    $project   = 'default',
    $host      = "$::hostname.dev",
    $extraPath = '',
    $vhost     = false,
    $dirs      = false,    
    $setup     = false,
  ) {

  $default_vhost = {
    'DocumentRoot' => "/var/www/vhosts/$project/$host/httpdocs/$extraPath",
    'ServerName'   => "$host",
    'ServerAlias'  => "www.$host",
    'ErrorLog'     => "/var/www/vhosts/$project/$host/logs/error_log",
    'TransferLog'  => "/var/www/vhosts/$project/$host/logs/access_log"
  }

  $final_vhost = $default_vhost

  $default_dirs = [
    "/var/www/vhosts/$project",
    "/var/www/vhosts/$project/$host",
    "/var/www/vhosts/$project/$host/httpdocs",
    "/var/www/vhosts/$project/$host/conf",
    "/var/www/vhosts/$project/$host/conf/httpd",
    "/var/www/vhosts/$project/$host/logs",
  ]

  $final_dirs = $default_dirs

  $default_setup = {
    'template' => 'httpd/vhost.auto.erb'
  }

  $final_setup = $default_setup

  file { $final_dirs:
      ensure => "directory",
      owner  => "root",
      group  => "www-data",
      mode   => 755,
  }

  file { "httpd_vhost_add_file":
    path    => "/var/www/vhosts/$project/$host/conf/httpd/vhost.conf",
    owner   => root,
    group   => root,
    mode    => 644,
    content => template($final_setup['template']),
    require => File['httpd_conf_directory'],
    notify  => Service['httpd'],
  }

  host { $host: ip => $ip,}

  # Append to vhosts include
}