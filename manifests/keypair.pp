define certs::keypair (
  $key_pair,
  $key_file,
  $cert_file,
  $manage_key  = false,
  $key_owner   = undef,
  $key_group   = undef,
  $key_mode    = undef,
  $manage_cert = false,
  $cert_owner  = undef,
  $cert_group  = undef,
  $cert_mode   = undef,
) {
  Cert[$key_pair] ~>
  privkey { $key_file:
    key_pair => Cert[$key_pair],
  } ~>
  pubkey { $cert_file:
    key_pair => Cert[$key_pair],
  }

  if $manage_key {
    file { $key_file:
      ensure  => file,
      owner   => $key_owner,
      group   => $key_group,
      mode    => $key_mode,
      require => Privkey[$key_file],
    }
  }

  if $manage_cert {
    file { $cert_file:
      ensure  => file,
      owner   => $cert_owner,
      group   => $cert_group,
      mode    => $cert_mode,
      require => Pubkey[$cert_file],
    }
  }
}
