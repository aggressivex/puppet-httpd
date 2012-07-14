include apache

$test = {
  {'project' => 'test', 'host' => 'node1.some.domain.com', 'ip' => '192.168.1.200', 'port' => '80',},
  {'project' => 'test', 'host' => 'node2.some.domain.com', 'ip' => '192.168.1.200', 'port' => '80',},
  {'project' => 'test', 'host' => 'node3.some.domain.com', 'ip' => '192.168.1.200', 'port' => '80',},
  {'project' => 'test', 'host' => 'node4.some.domain.com', 'ip' => '192.168.1.200', 'port' => '80',
    'virtualhost' => {
    'ErrorLog' => '/custom/errorLogPath',
    'Directory /var/www/vhosts/www' => {
      'AllowOverride' => 'All',
      'Allow'         => 'from all'
      }
    }      
  }
}

apache::vhosts { 'test.hosts': $test }