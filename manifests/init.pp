# == Class: sendmail
#
# Module for sendmail configuration.
#
# === Parameters
#
# [*sendmail_mc_template*]
#   Path to the sendmail.mc template
#
# [*smart_host*]
#  The smtp outgoing server
#
# [*exposed_user*]
#  The username to be displayed instead of the masquerade name
#
# [*masquerade_as*]
#  This causes mail being sent to be labeled as coming from the indicated host.domain
#
# [*masquerade_envelope*]
#  If masquerading is enabled or the genericstable is in use,
#  set this parameter to true to also masquerade envelopes,
#  normally only the header addresses are masqueraded
#
# [*masquerade_entire_domain*]
#  Set this to true if you need all hosts within the masquerading domains
#  to be rewritten to the masquerade name
#
# [*masquerade_domain*]
#  The effect of this is that although mail to user@otherhost.domain
#  will not be delivered locally, any mail including any user@otherhost.domain
#  will, when relayed, be rewritten to have the masquerade_as address;
#  this can be a space-separated list of names
#
# [*rootmail*]
#   Mail address for the root user, default is undef
#
# [*aliases*]
#   Hash of aliases. Example: { 'user' => 'email' }
#
# [*generics_domains*]
#   List of domains to serve. Example: [ 'domain1.com', 'domain2.com' }
#
# [*generics_table*]
#   Hash of user email addresses for multiple domains. Example: { 'user', 'email' }
#
# === Examples
#
#  class { sendmail:
#    sendmail_mc_template => 'mymodule/mytemplate.erb'
#  }
#
# === Authors
#
# Alessandro De Salvo <Alessandro.DeSalvo@roma1.infn.it>
#
# === Copyright
#
# Copyright 2014 Alessandro De Salvo.
#
class sendmail (
  $sendmail_mc_template     = $sendmail::params::sendmail_mc_tmpl,
  $smart_host               = undef,
  $exposed_user             = 'root',
  $masquerade_as            = false,
  $masquerade_envelope      = false,
  $masquerade_entire_domain = false,
  $masquerade_domain        = false,
  $rootmail                 = undef,
  $aliases                  = undef,
  $generics_domains         = undef,
  $generics_table           = undef,
) inherits sendmail::params {
    package { $sendmail::params::sendmail_pkgs: ensure => latest }

    file { $sendmail::params::sendmail_mc_path:
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template($sendmail::params::sendmail_mc_tmpl),
        require => Package[$sendmail::params::sendmail_pkgs],
        notify  => Exec ["make_sendmail_config"],
    }

    if ($aliases) {
        file { $sendmail::params::aliases_path:
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template($sendmail::params::aliases_tmpl),
            require => Package[$sendmail::params::sendmail_pkgs],
            notify  => Service[$sendmail::service_name],
        }
    } else {
        file { $sendmail::params::aliases_path: ensure => absent, notify => Service[$sendmail::service_name] }
    }

    if ($generics_domains) {
        file { $sendmail::params::generics_domains_path:
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template($sendmail::params::generics_domains_tmpl),
            require => Package[$sendmail::params::sendmail_pkgs],
            notify  => Service[$sendmail::service_name],
        }
    } else {
        file { $sendmail::params::generics_domains_path: ensure => absent, notify => Service[$sendmail::service_name] }
    }

    if ($generics_table) {
        file { $sendmail::params::generics_table_path:
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template($sendmail::params::generics_table_tmpl),
            require => Package[$sendmail::params::sendmail_pkgs],
            notify  => Service[$sendmail::service_name],
        }
    } else {
        file { $sendmail::params::generics_table_path: ensure => absent, notify => Service[$sendmail::service_name] }
    }

    exec { "make_sendmail_config" :
        command     => 'make -C /etc/mail',
        path        => [ "/bin", "/usr/bin" ],
        cwd         => '/etc/mail',
        refreshonly => true,
        notify      => Service[$sendmail::service_name],
    }

    if ($rootmail) {
        mailalias { "root mail alias":
            ensure    => present,
            name      => 'root',
            recipient => $rootmail,
            notify    => Service[$sendmail::service_name],
        }
    }

    service { "sendmail" :
        ensure  => running,
        enable  => true,
        require => Package[$sendmail::params::sendmail_pkgs],
    }
}
