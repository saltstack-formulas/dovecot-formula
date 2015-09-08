{% from "dovecot/map.jinja" import dovecot with context %}

dovecot_packages:
  pkg.installed:
    - pkgs: {{ dovecot.packages }}
    - watch_in:
      - service: dovecot_service

/etc/dovecot/{{ dovecot.config.filename }}.conf:
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

{% if dovecot.config.ssl_certs is defined and dovecot.config.ssl_certs is iterable %}
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
{% endif %}

{% if dovecot.config.ssl_keys is defined and dovecot.config.ssl_keys is iterable %}
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
{% endif %}

dovecot_service:
  service.running:
    - name: dovecot
    - watch:
      - file: /etc/dovecot/{{ dovecot.config.filename }}.conf
      - pkg: dovecot_packages
    - require:
      - pkg: dovecot_packages
{% if dovecot.enable_service_control is defined and dovecot.enable_service_control == false %}
    # never run this state
    - onlyif:
      - /bin/false
{% endif %}

