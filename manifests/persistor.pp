# Installs the vitrage persistor service
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
class vitrage::persistor (
  Boolean $manage_service                 = true,
  Boolean $enabled                        = true,
  Stdlib::Ensure::Package $package_ensure = 'present',
) {
  include vitrage::deps
  include vitrage::params

  package { 'vitrage-persistor':
    ensure => $package_ensure,
    name   => $vitrage::params::persistor_package_name,
    tag    => ['openstack', 'vitrage-package'],
  }

  vitrage_config {
    'persistency/enable_persistency': value => $enabled;
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }

    service { 'vitrage-persistor':
      ensure     => $service_ensure,
      name       => $vitrage::params::persistor_service_name,
      enable     => $enabled,
      hasstatus  => true,
      hasrestart => true,
      tag        => 'vitrage-service',
    }
  }
}
