/etc/dovecot/dovecot-ldap.pass.conf.ext:
  file.managed:
    - source: salt://dovecot/files/dovecot-ldap.conf.ext
    - template: jinja
    - mode: 600
    - user: root

/etc/dovecot/dovecot-ldap.user.conf.ext:
  file.managed:
    - source: salt://dovecot/files/dovecot-ldap.conf.ext
    - template: jinja
    - mode: 600
    - user: root
