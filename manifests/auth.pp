# DEPRECATED !!
# The vitrage::auth class helps configure auth settings
#
# == Parameters
# [*auth_url*]
#   (Optional) The keystone public endpoint
#   Defaults to 'http://localhost:5000/v3'
#
# [*auth_region*]
#   (Optional) The keystone region of this node
#   Defaults to 'RegionOne'
#
# [*auth_user*]
#   (Optional) The keystone user for vitrage services
#   Defaults to 'vitrage'
#
# [*auth_password*]
#   (Required) The keystone password for vitrage services
#
# [*auth_project_name*]
#   (Optional) The keystone tenant name for vitrage services
#   Defaults to 'services'
#
# [*project_domain_name*]
#   (Optional) The keystone project domain name for vitrage services
#   Defaults to 'Default'
#
# [*user_domain_name*]
#   (Optional) The keystone user domain id name vitrage services
#   Defaults to 'Default'
#
# [*auth_type*]
#   (Optional) An authentication type to use with an OpenStack Identity server.
#   The value should contain auth plugin name.
#   Defaults to 'password'.
#
# [*auth_cacert*]
#   (Optional) Certificate chain for SSL validation.
#   Defaults to $::os_service_default.
#
# [*interface*]
#   (Optional) Type of endpoint in Identity service catalog to use for
#   communication with OpenStack services.
#   Defaults to $::os_service_default.
#
class vitrage::auth (
  $auth_password,
  $auth_url             = 'http://localhost:5000/v3',
  $auth_region          = 'RegionOne',
  $auth_user            = 'vitrage',
  $auth_project_name    = 'services',
  $project_domain_name  = 'Default',
  $user_domain_name     = 'Default',
  $auth_type            = 'password',
  $auth_cacert          = $::os_service_default,
  $interface            = $::os_service_default,
) {

  include vitrage::deps

  warning('The vitrage::auth class has been deprecated. Use the vitrage::service_credentials class.')

  class { 'vitrage::service_credentials':
    auth_url            => $auth_url,
    region_name         => $auth_region,
    username            => $auth_user,
    password            => $auth_password,
    project_name        => $auth_project_name,
    user_domain_name    => $user_domain_name,
    project_domain_name => $project_domain_name,
    cacert              => $auth_cacert,
    interface           => $interface,
    auth_type           => $auth_type,
  }
}
