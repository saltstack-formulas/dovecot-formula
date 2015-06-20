{% from "dovecot/map.jinja" import dovecot with context %}

dovecot_packages:
  pkg.installed:
    - pkgs: {{ dovecot.packages }}
    - watch_in:
      - service: dovecot_service

{% if grains['os'] == 'Arch' %}
/etc/dovecot/dovecot.conf:
{% else %}
/etc/dovecot/local.conf:
{% endif %}
  file.managed:
    - contents: |
        {{ dovecot.config.local | indent(8) }}
    - backup: minion
    - watch_in:
      - service: dovecot_service
    - require:
      - pkg: dovecot_packages

{% for name in dovecot.config.dovecotext %}
/etc/dovecot/dovecot-{{ name }}.conf.ext:
  file.managed:
    - contents: |
        {{ dovecot.config.dovecotext[name] | indent(8) }}
    - backup: minion
    - watch_in:
      - service: dovecot_service
    - require:
      - pkg: dovecot_packages
{% endfor %}

{% for name in dovecot.config.conf %}
/etc/dovecot/conf.d/{{ name }}.conf:
  file.managed:
    - contents: |
        {{ dovecot.config.conf[name] | indent(8) }}
    - backup: minion
    - watch_in:
      - service: dovecot_service
    - require:
      - pkg: dovecot_packages
{% endfor %}

{% for name in dovecot.config.confext %}
/etc/dovecot/conf.d/{{ name }}.conf.ext:
  file.managed:
    - contents: |
        {{ dovecot.config.confext[name] | indent(8) }}
    - backup: minion
    - watch_in:
      - service: dovecot_service
    - require:
      - pkg: dovecot_packages
{% endfor %}

{% for name in dovecot.config.ssl_certs %}
/etc/ssl/private/dovecot-{{ name }}.crt:
  file.managed:
    - contents: |
        {{ dovecot.config.ssl_certs[name] | indent(8) }}
    - user: nobody
    - group: nobody
    - mode: 444
    - backup: minion
    - watch_in:
      - service: dovecot_service
    - require:
      - pkg: dovecot_packages
{% endfor %}

{% for name in dovecot.config.ssl_keys %}
/etc/ssl/private/dovecot-{{ name }}.key:
  file.managed:
    - contents: |
        {{ dovecot.config.ssl_keys[name] | indent(8) }}
    - user: nobody
    - group: nobody
    - mode: 400
    - backup: minion
    - watch_in:
      - service: dovecot_service
    - require:
      - pkg: dovecot_packages
{% endfor %}

dovecot_service:
  service.running:
    - name: dovecot
    - watch:
{% if grains['os'] == 'Arch' %}
      - file: /etc/dovecot/dovecot.conf
{% else %}
      - file: /etc/dovecot/local.conf
{% endif %}
      - pkg: dovecot_packages
    - require:
      - pkg: dovecot_packages

