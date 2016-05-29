#
# Installs the vitrage python library.
#
# == parameters
#  [*ensure*]
#    ensure state for package.
#
class vitrage::client (
  $ensure = 'present'
) {

  include ::vitrage::params

  package { 'python-vitrageclient':
    ensure => $ensure,
    name   => $::vitrage::params::client_package_name,
    tag    => 'openstack',
  }

}

