# Class: apache
#
# This class installs httpd for CentOS / RHEL It setup a wildcard vhosts 
# "include" also, so it will include al conf files following this pattern 
# "/var/www/*:projectName/*:hostName/conf/httpd/*" in this way, we will keep 
# our VirtualHost files inside each host directory.
#
define httpd::setup (
    $httpdSetup = {},
    $firewall = false,
    $firewallPort = 80
  ) {

  include conf

  $conf_httpd_override = $httpdSetup

  $conf_httpd_default = $conf::default
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

  group { $conf_httpd_default['Group']:
    ensure  => "present",
    require => Package ['httpd'],
  }

  user { $conf_httpd_default['User']:
    ensure     => "present",
    managehome => false,
    groups     => [$conf_httpd_default['Group']],
    require    => Package ['httpd'],
  }

  file { 'httpd_conf_directory':
    ensure  => directory,
    path    => $conf_setup['conf_path'],
    recurse => true,
    purge   => false,
    require => Package['httpd'],
  }

  file { "httpd_conf_file":
    path    => "/etc/httpd/conf/httpd.conf",
    owner   => root,
    group   => root,
    mode    => 644,
    content => template($conf_setup['conf_template']),
    require => [Package['httpd'], File['httpd_conf_directory']],
    notify  => Service['httpd'],
  }

  $setup_dirs = [
    "/var/www",
    "/var/www/vhosts"
  ]

  file { $setup_dirs:
    ensure => "directory"
  }

  service { 'httpd':
    name       => 'httpd',  
    ensure     => 'running',
    enable     => true,    
    hasrestart => true,
    hasstatus  => true,
    require    => Package ['httpd']
  }

  case $firewall {
    csf: {
      csf::port::open {'httpd-firewall-csf-open': 
        port => $defaultSetup['port']
      }
    }
    iptables: {
      exec { "httpd-firewall-iptables-add":
        command => "iptables -I INPUT 5 -p tcp --dport $firewallPort -j ACCEPT",
        path    => "/usr/local/bin/:/bin/:/usr/bin/:/usr/sbin:/sbin/",
        require => Package["httpd"]
      }      
      exec { "httpd-firewall-iptables-save":
        command => "service iptables save",
        path    => "/usr/local/bin/:/bin/:/usr/bin/:/usr/sbin:/sbin/",
        require => Exec["httpd-firewall-iptables-add"]
      }
    }
  }
}
