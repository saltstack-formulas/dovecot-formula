===============
dovecot-formula
===============

A saltstack formula that installs and configures the dovecot IMAP server. It is currently designed to support debian
or ubuntu layout of the dovecot configuration files. The dovecot packages must be specified (imapd is installed by
default). Config file content (where needed) is stored in pillar (see pillar.example).

.. code::
  /etc/dovecot/local.conf in dovecot:config:local

e.g.:
.. code::
  /etc/dovecot/dovecot-ldap.conf.ext in dovecot:config:dovecotext:ldap
  /etc/dovecot/conf.d/auth-ldap.conf.ext in dovecot:config:confext:ldap
  /etc/dovecot/conf.d/10-ldap.conf in dovecot:config:conf:10-ldap


Available states
================

.. contents::
    :local:

``dovecot``
------------

Installs and configures the dovecot package, and starts the associated dovecot service.
