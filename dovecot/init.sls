{% from "dovecot/map.jinja" import dovecot with context %}

dovecot_packages:
  pkg.installed:
    - pkgs: {{ dovecot.packages + salt['pillar.get']('dovecot:extra_packages', []) }}
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

{% for name, content in dovecot.config.dovecotext.items() %}
/etc/dovecot/dovecot-{{ name }}.conf.ext:
  file.managed:
    - contents: |
        {{ content | indent(8) }}
    - backup: minion
    - watch_in:
      - service: dovecot_service
    - require:
      - pkg: dovecot_packages
{% endfor %}

{% for name, content in dovecot.config.conf.items() %}
/etc/dovecot/conf.d/{{ name }}.conf:
  file.managed:
    - contents: |
        {{ content | indent(8) }}
    - backup: minion
    - watch_in:
      - service: dovecot_service
    - require:
      - pkg: dovecot_packages
{% endfor %}

{% for name, content in dovecot.config.confext.items() %}
/etc/dovecot/conf.d/{{ name }}.conf.ext:
  file.managed:
    - contents: |
        {{ content | indent(8) }}
    - backup: minion
    - watch_in:
      - service: dovecot_service
    - require:
      - pkg: dovecot_packages
{% endfor %}

{% for name, content in dovecot.config.ssl_certs.items() %}
{{ dovecot.config.ssl_certs_dir }}/dovecot-{{ name }}.crt:
  file.managed:
    - contents: |
        {{ content | indent(8) }}
    - user: root
    - group: root
    - mode: 444
    - backup: minion
    - watch_in:
      - service: dovecot_service
    - require:
      - pkg: dovecot_packages
{% endfor %}

{% for name, content in dovecot.config.ssl_keys.items() %}
{{ dovecot.config.ssl_keys_dir }}/dovecot-{{ name }}.key:
  file.managed:
    - contents: |
        {{ content | indent(8) }}
    - user: root
    - group: root
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
      - file: /etc/dovecot/{{ dovecot.config.filename }}.conf
      - pkg: dovecot_packages
    - require:
      - pkg: dovecot_packages
{% if dovecot.get('service_persistent', True) %}
    - enable: True
{% endif %}
{% if 'enable_service_control' in dovecot and dovecot.enable_service_control == false %}
    # never run this state
    - onlyif:
      - /bin/false
{% endif %}

