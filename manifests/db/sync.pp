#
# Class to execute vitrage-manage db_sync
#
# == Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the vitrage-dbsync command.
#   Defaults to undef
#
class vitrage::db::sync(
  $extra_params  = undef,
) {
  exec { 'vitrage-db-sync':
    command     => "vitrage-manage db_sync ${extra_params}",
    path        => '/usr/bin',
    user        => 'vitrage',
    refreshonly => true,
    subscribe   => [Package['vitrage'], Vitrage_config['database/connection']],
  }

  Exec['vitrage-manage db_sync'] ~> Service<| title == 'vitrage' |>
}
