puppet-sendmail
======

Puppet module for managing sendmail configuration.

#### Table of Contents
1. [Overview - What is the sendmail module?](#overview)

Overview
--------

This module manages and confgiures the sendmail agent.

Parameters
----------

* **sendmail_mc_template**: path to the sendmail.mc template
* **smart_host**: the smtp outgoing server
* **exposed_user**: the username to be displayed instead of the masquerade name
* **masquerade_as**: this causes mail being sent to be labeled as coming from the indicated host.domain
* **masquerade_envelope**: if masquerading is enabled or the genericstable is in use, set this parameter to true to also masquerade envelopes, normally only the header addresses are masqueraded
* **masquerade_entire_domain**: set this to true if you need all hosts within the masquerading domains to be rewritten to the masquerade name
* **masquerade_domain**: the effect of this is that although mail to user@otherhost.domain will not be delivered locally, any mail including any user@otherhost.domain will, when relayed, be rewritten to have the masquerade_as address; this can be a space-separated list of names
* **rootmail**: mail address for the root user, default is undef
* **aliases**: hash of aliases. Example: { 'user' => 'email' }
* **generics_domains**: list of domains to serve. Example: [ 'domain1.com', 'domain2.com' }
* **generics_table**: hash of user email addresses for multiple domains. Example: { 'user', 'email' }
* **is_relay**: bool, set to 1 if you want the server to be a relay
* **relay-domains**: list of domains to relay for. Example: { 'example.com', 'example2.co.uk' }
* **listen_ip**: Single IP address that the server should listen on. Example: 127.0.0.1
* **authinfo**: Authorization array, host based. Omit host for default authorization. Example: [ { 'host' => 'smtp.gmail.com', 'userId' => 'root', 'authenticationId' => 'myusername', 'password' => 'mypassword', 'realm' => 'realmifany', 'mechanisms' => 'MECH1 MECH2 ... MECHn' }, { ... }, ... ]

Usage
-----

### Example

This is and example of setting up the sendmail agent using the default configuration.

**Using the sendmail module**

```sendmail
class { 'sendmail': }
```

Contributors
------------

* https://github.com/desalvo/puppet-sendmail/graphs/contributors

Release Notes
-------------

**0.1.3**

* Added relayer functionality
* Added listen_ip setting

**0.1.2**

* Template fix

**0.1.1**

* Fix for path to the make command

**0.1.0**

* Initial version
