# Installs the vitrage notifier service
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
#  [*notifiers*]
#    (optional) Names of enabled notifiers.
#    Defaults to $facts['os_service_default'].
#
class vitrage::notifier (
  $manage_service = true,
  $enabled        = true,
  $package_ensure = 'present',
  $notifiers      = $facts['os_service_default'],
) {

  include vitrage::deps
  include vitrage::params

  package { 'vitrage-notifier':
    ensure => $package_ensure,
    name   => $::vitrage::params::notifier_package_name,
    tag    => ['openstack', 'vitrage-package']
  }

  vitrage_config {
    'DEFAULT/notifiers': value => join(any2array($notifiers), ',');
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }

    service { 'vitrage-notifier':
      ensure     => $service_ensure,
      name       => $::vitrage::params::notifier_service_name,
      enable     => $enabled,
      hasstatus  => true,
      hasrestart => true,
      tag        => 'vitrage-service',
    }
  }
}
