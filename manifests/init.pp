# Class: apache
#
# This class installs httpd for CentOS / RHEL It setup a wildcard vhosts 
# "include" also, so it will include al conf files following this pattern 
# "/var/www/*:projectName/*:hostName/conf/httpd/*" in this way, we will keep 
# our VirtualHost files inside each host directory.
#
class httpd {

  include conf

  $conf_httpd = $conf::default
  $conf_setup = $conf::setup

  $dependencies = ["make", "gcc", "openssl-devel", "apr-devel", "apr-util-devel"]

  package { $dependencies: 
    ensure => installed 
  }

  package { 'httpd':
    ensure => installed,
    name   => 'httpd',
    require => [
      Package['make'],
      Package['gcc'],
      Package['openssl-devel'],
      Package['apr-devel'],
      Package['apr-util-devel'],
    ]
  }

  group { $conf_httpd['Group']:
    ensure  => "present",
    require => Package ['httpd'],
  }

  user { $conf_httpd['User']:
    ensure     => "present",
    managehome => false,
    groups     => [$conf_httpd['Group']],
    require    => Package ['httpd'],
  }

  file { 'httpd_conf_directory':
    ensure  => directory,
    path    => $conf_setup['conf_path'],
    recurse => true,
    purge   => true,
    require => Package['httpd'],
  }

  file { "httpd_conf_file":
    path    => "/etc/httpd/conf/httpd.conf",
    owner   => root,
    group   => root,
    mode    => 644,
    content => template($conf_setup['conf_template']),
    require => File['httpd_conf_directory']
  }

  file { "httpd_conf_vhost_include":
    path    => $conf_setup['conf_vhost_include_path'],
    ensure  => "present",
    content => $conf_setup['conf_vhost_include_pattern'],
    mode    => 644,
    require => File['httpd_conf_directory']
  }

  service { 'httpd':
    name       => 'httpd',  
    ensure     => 'running',
    enable     => true,    
    hasrestart => true,
    hasstatus  => true,
    require    => Package ['httpd']
  }
}
