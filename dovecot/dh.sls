{%- from "dovecot/map.jinja" import dovecot with context %}

dovecot-dh-create-dhparam-file:
  cmd.run:
    - name: "openssl dhparam {{ dovecot.ssl.dhparam.numbits }} > {{ dovecot.ssl.dhparam.path }}"
    - creates: {{ dovecot.ssl.dhparam.path }}
    - watch_in:
      - service: dovecot_service
