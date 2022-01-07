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

  vitrage_config {
    'service_credentials/auth_url'            : value => $auth_url;
    'service_credentials/region_name'         : value => $auth_region;
    'service_credentials/username'            : value => $auth_user;
    'service_credentials/password'            : value => $auth_password, secret => true;
    'service_credentials/project_name'        : value => $auth_project_name;
    'service_credentials/user_domain_name'    : value => $user_domain_name;
    'service_credentials/project_domain_name' : value => $project_domain_name;
    'service_credentials/cacert'              : value => $auth_cacert;
    'service_credentials/interface'           : value => $interface;
    'service_credentials/auth_type'           : value => $auth_type;
  }
}
