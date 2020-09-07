# Set the time zone for all nodes
# TODO: Not sure about the UTC timezone; at least it should be configurable
class profile::timezone {
  class { 'timezone':
    timezone => 'Etc/UTC',
  }
}
