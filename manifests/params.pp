# == Class: vitrage::params
#
# Parameters for puppet-vitrage
#
class vitrage::params {

  $client_package_name = 'python-vitrageclient'

  case $::osfamily {
    'RedHat': {
      $api_package_name           = 'openstack-vitrage-api'
      $api_service_name           = 'openstack-vitrage-api'
      $vitrage_wsgi_script_path   = '/var/www/cgi-bin/vitrage'
      $vitrage_wsgi_script_source = '/usr/lib/python2.7/site-packages/vitrage/api/app.wsgi'
    }
    'Debian': {
      $api_package_name           = 'vitrage-api'
      $api_service_name           = 'vitrage-api'
      $vitrage_wsgi_script_path   = '/usr/lib/cgi-bin/vitrage'
      $vitrage_wsgi_script_source = '/usr/share/vitrage-common/app.wsgi'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}
