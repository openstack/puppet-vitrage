# The vitrage::service_credentials class helps configure service_credentials settings
#
# == Parameters
#
# [*password*]
#   (Required) The keystone password for vitrage services
#
# [*auth_url*]
#   (Optional) The keystone public endpoint
#   Defaults to 'http://localhost:5000'
#
# [*region_name*]
#   (Optional) The keystone region of this node
#   Defaults to 'RegionOne'
#
# [*username*]
#   (Optional) The keystone user for vitrage services
#   Defaults to 'vitrage'
#
# [*project_name*]
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
# [*cacert*]
#   (Optional) Certificate chain for SSL validation.
#   Defaults to $::os_service_default.
#
# [*interface*]
#   (Optional) Type of endpoint in Identity service catalog to use for
#   communication with OpenStack services.
#   Defaults to $::os_service_default.
#
class vitrage::service_credentials (
  $password,
  $auth_url            = 'http://localhost:5000',
  $region_name         = 'RegionOne',
  $username            = 'vitrage',
  $project_name        = 'services',
  $project_domain_name = 'Default',
  $user_domain_name    = 'Default',
  $auth_type           = 'password',
  $cacert              = $::os_service_default,
  $interface           = $::os_service_default,
) {

  include vitrage::deps

  vitrage_config {
    'service_credentials/auth_url'            : value => $auth_url;
    'service_credentials/region_name'         : value => $region_name;
    'service_credentials/username'            : value => $username;
    'service_credentials/password'            : value => $password, secret => true;
    'service_credentials/project_name'        : value => $project_name;
    'service_credentials/user_domain_name'    : value => $user_domain_name;
    'service_credentials/project_domain_name' : value => $project_domain_name;
    'service_credentials/cacert'              : value => $cacert;
    'service_credentials/interface'           : value => $interface;
    'service_credentials/auth_type'           : value => $auth_type;
  }
}
