# Installs the vitrage collector service
#
# DEPRECATED!
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
class vitrage::collector (
  $manage_service = true,
  $enabled        = true,
  $package_ensure = 'present',
) {

  warning('vitrage::collector is deprecated, has no effect and will be removed in the T release')
}
