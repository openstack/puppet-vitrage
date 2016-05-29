# The vitrage::auth class helps configure auth settings
#
# == Parameters
#  [*auth_url*]
#    the keystone public endpoint
#    Optional. Defaults to 'http://localhost:5000'
#
#  [*auth_region*]
#    the keystone region of this node
#    Optional. Defaults to 'RegionOne'
#
#  [*auth_user*]
#    the keystone user for vitrage services
#    Optional. Defaults to 'vitrage'
#
#  [*auth_password*]
#    the keystone password for vitrage services
#    Required.
#
#  [*auth_tenant_name*]
#    the keystone tenant name for vitrage services
#    Optional. Defaults to 'services'
#
#  [*auth_tenant_id*]
#    the keystone tenant id for vitrage services.
#    Optional. Defaults to $::os_service_default.
#
#  [*auth_cacert*]
#    Certificate chain for SSL validation.
#    Optional. Defaults to $::os_service_default.
#
#  [*auth_endpoint_type*]
#    Type of endpoint in Identity service catalog to use for
#    communication with OpenStack services.
#    Optional. Defaults to $::os_service_default.
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
