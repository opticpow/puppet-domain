class domain (
    $username      = undef,
    $password      = undef,
    $join          = false,
    $requiredgroup = 'nibdom.com+domain^users',
    $loginshell    = '/bin/bash',
    $sambainterop = false
) {
  $grep_command = $::osfamily ? {
    /(?i:RedHat)/ => '/bin/grep',
    /(?i:Debian)/ => '/bin/grep',
    /(?i:Suse)/   => '/usr/bin/grep',
    default       => '/bin/grep',
  }
      
  $ensure = $join ? {
      true    => 'present',
      default => 'absent',}

  package { 'pbis-open':
      ensure  => present,
      require => Class['localrepo'];
  }

  domain { $::domain:
      ensure          => $ensure,
      username        => $username,
      password        => $password,
      shortlogin      => true,
      requiredgroup   => $requiredgroup,
      domainseparator => '+',
      loginshell      => $loginshell,
      require         => Package['pbis-open'];
  }

  if $sambainterop {
    exec { 'samba-interop-install':
      command =>'/opt/pbis/bin/samba-interop-install --install',
      unless  => "/usr/bin/net ads testjoin -k | ${grep_command} -ic OK",
      #require => Package['samba']
    }
  }
}
