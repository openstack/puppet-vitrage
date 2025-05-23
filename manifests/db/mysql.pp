# The vitrage::db::mysql class implements mysql backend for vitrage
#
# This class can be used to create tables, users and grant
# privileges for a mysql vitrage database.
#
# == Parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'vitrage'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'vitrage'.
#
# [*host*]
#   (Optional) The default source host user is allowed to connect from.
#   Defaults to '127.0.0.1'
#
# [*allowed_hosts*]
#   (Optional) Other hosts the user is allowed to connect from.
#   Defaults to undef.
#
# [*charset*]
#   (Optional) The database charset.
#   Defaults to 'utf8'
#
# [*collate*]
#   (Optional) The database collate.
#   Only used with mysql modules >= 2.2.
#   Defaults to 'utf8_general_ci'
#
class vitrage::db::mysql(
  String[1] $password,
  $dbname        = 'vitrage',
  $user          = 'vitrage',
  $host          = '127.0.0.1',
  $charset       = 'utf8',
  $collate       = 'utf8_general_ci',
  $allowed_hosts = undef
) {

  include vitrage::deps

  openstacklib::db::mysql { 'vitrage':
    user          => $user,
    password      => $password,
    dbname        => $dbname,
    host          => $host,
    charset       => $charset,
    collate       => $collate,
    allowed_hosts => $allowed_hosts,
  }

  Anchor['vitrage::db::begin']
  ~> Class['vitrage::db::mysql']
  ~> Anchor['vitrage::db::end']

}
