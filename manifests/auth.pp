# The vitrage::auth class helps configure auth settings
#
# == Parameters
# [*auth_url*]
#   (Optional) The keystone public endpoint
#   Defaults to 'http://localhost:5000'
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
# [*auth_tenant_name*]
#   (Optional) The keystone tenant name for vitrage services
#   Defaults to 'services'
#
# [*auth_tenant_id*]
#   (Optional) The keystone tenant id for vitrage services.
#   Defaults to $::os_service_default.
#
# [*auth_cacert*]
#   (Optional) Certificate chain for SSL validation.
#   Defaults to $::os_service_default.
#
# [*auth_endpoint_type*]
#   (Optional) Type of endpoint in Identity service catalog to use for
#   communication with OpenStack services.
#   Defaults to $::os_service_default.
#
class vitrage::auth (
  $auth_password,
  $auth_url           = 'http://localhost:5000',
  $auth_region        = 'RegionOne',
  $auth_user          = 'vitrage',
  $auth_tenant_name   = 'services',
  $auth_tenant_id     = $::os_service_default,
  $auth_cacert        = $::os_service_default,
  $auth_endpoint_type = $::os_service_default,
) {

  include ::vitrage::deps

  vitrage_config {
    'service_credentials/os_auth_url'      : value => $auth_url;
    'service_credentials/os_region_name'   : value => $auth_region;
    'service_credentials/os_username'      : value => $auth_user;
    'service_credentials/os_password'      : value => $auth_password, secret => true;
    'service_credentials/os_tenant_name'   : value => $auth_tenant_name;
    'service_credentials/os_tenant_id'     : value => $auth_tenant_id;
    'service_credentials/os_endpoint_type' : value => $auth_endpoint_type;
    'service_credentials/os_cacert'        : value => $auth_cacert
  }


}
