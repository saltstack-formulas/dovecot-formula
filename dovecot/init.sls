{% from "dovecot/map.jinja" import dovecot with context %}

dovecot_packages:
  pkg.installed:
    - pkgs: {{ (dovecot.packages + salt['pillar.get']('dovecot:extra_packages', [])) | json }}
    - watch_in:
      - service: dovecot_service

{{ dovecot.config.base }}/{{ dovecot.config.filename }}.conf:
  file.managed:
    - contents: |
        {{ dovecot.config.local | indent(8) }}
    - backup: minion
    - watch_in:
      - service: dovecot_service
    - require:
      - pkg: dovecot_packages

{% for name, content in dovecot.config.dovecotext.items() %}
{{ dovecot.config.base }}/dovecot-{{ name }}.conf.ext:
  file.managed:
    - contents: |
        {{ content | indent(8) }}
    - backup: minion
    - user: root
    - group: {{ dovecot.root_group }}
    - mode: 600
    - watch_in:
      - service: dovecot_service
    - require:
      - pkg: dovecot_packages
{% endfor %}

{% for name, content in dovecot.config.conf.items() %}
{{ dovecot.config.base }}/conf.d/{{ name }}.conf:
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
{{ dovecot.config.base }}/conf.d/{{ name }}.conf.ext:
  file.managed:
    - contents: |
        {{ content | indent(8) }}
    - backup: minion
    - watch_in:
      - service: dovecot_service
    - require:
      - pkg: dovecot_packages
{% endfor %}

{% for domain, content in dovecot.config.get('passwd_files', {}).items() %}
{% if loop.first %}
{{ dovecot.config.base }}/auth.d:
  file.directory:
    - user: root
    - group: dovecot
    - mode: 750
{% endif %}
{{ dovecot.config.base }}/auth.d/{{ domain }}.passwd:
  file.managed:
    - user: root
    - group: dovecot
    - mode: 640
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
    - group: {{ dovecot.root_group }}
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
    - group: {{ dovecot.root_group }}
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
      - file: {{ dovecot.config.base }}/{{ dovecot.config.filename }}.conf
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

# This is just here so we can force a restart via a watch_in.
dovecot_service_restart:
  service.running:
    - name: dovecot
    - watch:
      - pkg: dovecot_packages
{% if 'enable_service_control' in dovecot and dovecot.enable_service_control == false %}
    # never run this state
    - onlyif:
      - /bin/false
{% endif %}
