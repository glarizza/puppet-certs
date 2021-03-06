# Handles Foreman certs configuration
class certs::foreman (
  $hostname       = $::certs::node_fqdn,
  $cname          = $::certs::cname,
  $generate       = $::certs::generate,
  $regenerate     = $::certs::regenerate,
  $deploy         = $::certs::deploy,
  $client_cert    = $::certs::params::foreman_client_cert,
  $client_key     = $::certs::params::foreman_client_key,
  $ssl_ca_cert    = $::certs::params::foreman_ssl_ca_cert
) inherits certs::params {

  $client_cert_name = "${hostname}-foreman-client"

  # cert for authentication of puppetmaster against foreman
  cert { $client_cert_name:
    hostname      => $hostname,
    cname         => $cname,
    purpose       => 'client',
    country       => $::certs::country,
    state         => $::certs::state,
    city          => $::certs::city,
    org           => 'FOREMAN',
    org_unit      => 'PUPPET',
    expiration    => $::certs::expiration,
    ca            => $::certs::default_ca,
    generate      => $generate,
    regenerate    => $regenerate,
    deploy        => $deploy,
    password_file => $::certs::ca_key_password_file,
  }

  if $deploy {
    certs::keypair { 'foreman':
      key_pair   => $client_cert_name,
      key_file   => $client_key,
      manage_key => true,
      key_owner  => 'foreman',
      key_mode   => '0400',
      cert_file  => $client_cert,
    } ->
    pubkey { $ssl_ca_cert:
      key_pair => $::certs::server_ca,
    }
  }
}
