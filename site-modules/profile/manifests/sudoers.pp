# Manage user privileges
# TODO: I don't know what's the state of this config, but sudo should still ask for the user's password.
class profile::sudoers {
  sudo::conf { 'secure_path':
    content  => 'Defaults      secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/puppetlabs/puppet/bin:/opt/puppetlabs/bin"',
    priority => 0,
  }
  $sudoers = lookup('sudo_users', Array[String], 'unique', [])
  $sudoers.each | String $user | {
    sudo::conf { $user:
      content  => "${user} ALL=(ALL) NOPASSWD: ALL",
      priority => 10,
    }
  }
}
