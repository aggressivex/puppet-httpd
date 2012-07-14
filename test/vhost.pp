include apache
apache::vhost { 'test.vhost':
  template      => 'vhost.default.erb',
  ip            => '192.168.1.200',
  port          => 80,
  DocumentRoot  => '/tmp/testvhost',
  ServerName    => 'test.vhost'
  ServerAlias   => 'test.vhost'
  ServerAdmin   => 'webmaster@host.example.com'
  ErrorLog      => ''
  TransferLog   => ''
}