# Parameters for puppet-vitrage
#
class vitrage::params {

  case $::osfamily {
    'RedHat': {
      $api_package_name           = 'openstack-vitrage-api'
      $api_service_name           = 'openstack-vitrage-api'
      $vitrage_wsgi_script_path   = '/var/www/cgi-bin/vitrage'
      $vitrage_wsgi_script_source = '/usr/lib/python2.7/site-packages/vitrage/api/app.wsgi'
      $sqlite_package_name        = undef
      $pymysql_package_name       = undef
    }
    'Debian': {
      $api_package_name           = 'vitrage-api'
      $api_service_name           = 'vitrage-api'
      $vitrage_wsgi_script_path   = '/usr/lib/cgi-bin/vitrage'
      $vitrage_wsgi_script_source = '/usr/share/vitrage-common/app.wsgi'
      $sqlite_package_name        = 'python-pysqlite2'
      $pymysql_package_name       = 'python-pymysql'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}
