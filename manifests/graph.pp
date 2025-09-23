# Installs the vitrage graph service
#
# == Params
#  [*enabled*]
#    (optional) Should the service be enabled.
#    Defaults to true.
#
#  [*manage_service*]
#    (optional)  Whether the service should be managed by Puppet.
#    Defaults to true.
#
#  [*package_ensure*]
#    (optional) ensure state for package.
#    Defaults to 'present'
#
class vitrage::graph (
  Boolean $manage_service                 = true,
  Boolean $enabled                        = true,
  Stdlib::Ensure::Package $package_ensure = 'present',
) {
  include vitrage::deps
  include vitrage::params

  package { 'vitrage-graph':
    ensure => $package_ensure,
    name   => $vitrage::params::graph_package_name,
    tag    => ['openstack', 'vitrage-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }

    service { 'vitrage-graph':
      ensure     => $service_ensure,
      name       => $vitrage::params::graph_service_name,
      enable     => $enabled,
      hasstatus  => true,
      hasrestart => true,
      tag        => 'vitrage-service',
    }
  }
}
