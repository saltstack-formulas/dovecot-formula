{% from "dovecot/map.jinja" import dovecot with context %}

{% if grains['os_family'] == 'Debian' %}

dovecot_packages:
  pkg.installed:
    - names:
{% for name in dovecot.packages %}
      - dovecot-{{ name }}
{% endfor %}
    - watch_in:
      - service: dovecot_service

{% if salt['pillar.get']('dovecot:config:local', False) %}
/etc/dovecot/local.conf:
  file.managed:
    - contents_pillar: 'dovecot:config:local'
    - backup: minion
    - watch_in:
      - service: dovecot_service
{% endif %}

{% if salt['pillar.get']('dovecot:config:dovecotext', False) %}
{% for name in salt['pillar.get']('dovecot:config:dovecotext') %}
/etc/dovecot/dovecot-{{ name }}.conf.ext:
  file.managed:
    - contents_pillar: 'dovecot:config:dovecotext:{{ name }}'
    - backup: minion
    - watch_in:
      - service: dovecot_service
{% endfor %}
{% endif %}

{% if salt['pillar.get']('dovecot:config:conf', False) %}
{% for name in salt['pillar.get']('dovecot:config:conf') %}
/etc/dovecot/conf.d/dovecot-{{ name }}.conf:
  file.managed:
    - contents_pillar: 'dovecot:config:conf:{{ name }}'
    - backup: minion
    - watch_in:
      - service: dovecot_service
{% endfor %}
{% endif %}

{% if salt['pillar.get']('dovecot:config:confext', False) %}
{% for name in salt['pillar.get']('dovecot:config:confext') %}
/etc/dovecot/conf.d/{{ name }}.conf.ext:
  file.managed:
    - contents_pillar: 'dovecot:config:confext:{{ name }}'
    - backup: minion
    - watch_in:
      - service: dovecot_service
{% endfor %}
{% endif %}

dovecot_service:
  service.running:
    - name: dovecot
    - watch:
      - file: /etc/dovecot/local.conf
      - pkg: dovecot_packages

{% endif %}
