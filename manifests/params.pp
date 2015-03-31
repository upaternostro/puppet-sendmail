class sendmail::params {
  $sendmail_pkgs         = ['sendmail', 'sendmail-cf']
  $sendmail_mc_path      = '/etc/mail/sendmail.mc'
  $sendmail_mc_tmpl      = 'sendmail/sendmail.mc.erb'
  $aliases_path          = '/etc/mail/aliases'
  $aliases_tmpl          = 'sendmail/aliases.erb'
  $relay_domains_path    = '/etc/mail/relay-domains'
  $relay_domains_tmpl    = 'sendmail/relay-domains.erb'
  $is_relay              = 'sendmail/relay-domains.erb'
  $relay_domains         = ['example.com', 'example.co.uk']
  $generics_domains_path = '/etc/mail/generics-domains'
  $generics_domains_tmpl = 'sendmail/generics-domains.erb'
  $generics_table_path   = '/etc/mail/genericstable'
  $generics_table_tmpl   = 'sendmail/genericstable.erb'
  $service_name          = 'sendmail'
  $listen_ip              = '127.0.0.1'
}
