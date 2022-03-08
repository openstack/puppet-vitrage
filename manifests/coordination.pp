# == Class: vitrage::coordination
#
# Setup and configure Vitrage coordination settings.
#
# === Parameters
#
# [*backend_url*]
#   (Optional) Coordination backend URL.
#   Defaults to $::os_service_default
#
class vitrage::coordination (
  $backend_url = $::os_service_default,
) {

  include vitrage::deps

  oslo::coordination{ 'vitrage_config':
    backend_url => $backend_url
  }
}
