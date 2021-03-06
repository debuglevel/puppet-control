# Set up Puppet config and cron run
class profile::puppetclient {
  # ensure stopped and disabled puppet services, as they run from cron
  service { ['puppet', 'mcollective', 'pxp-agent']:
    ensure => stopped,
    enable => false,
  }

  include cron # ensures cron is installed
  cron::job { 'run-puppet':
    ensure  => present,
    command => '/usr/local/bin/run-puppet',
    minute  => '*/10',
    hour    => '*',
  }

  file { '/usr/local/bin/run-puppet':
    source => 'puppet:///modules/profile/puppet/run-puppet.sh',
    mode   => '0755',
  }

  ## TODO: this is seems not to be used
  #file { '/usr/local/bin/papply':
  #  source => 'puppet:///modules/profile/puppet/papply.sh',
  #  mode   => '0755',
  #}
}
