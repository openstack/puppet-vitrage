# == Class: vitrage
#
# Full description of class vitrage here.
#
# === Parameters
#
# [*ensure_package*]
#   (optional) The state of vitrage packages
#   Defaults to 'present'
#
class vitrage (
  $ensure_package  = 'present',
) inherits vitrage::params {


  package { 'vitrage':
    ensure => $ensure_package,
    name   => $::vitrage::params::common_package_name,
    tag    => ['openstack', 'vitrage-package'],
  }

}
