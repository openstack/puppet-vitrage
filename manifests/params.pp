# Parameters for puppet-vitrage
#
class vitrage::params {

  case $::osfamily {
    'RedHat': {
      $sqlite_package_name  = undef
    }
    'Debian': {
      $sqlite_package_name  = 'python-pysqlite2'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}
