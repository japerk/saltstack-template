{% set hosts = salt['pillar.get']('network:hosts', {}).items() %}

{% if hosts %}
{% for name, ip in hosts %}
{{ name }}:
  host.present:
    - ip: {{ ip }}
{% endfor %}

hosts_debian_tmpl:
  file.append:
    - name: /etc/cloud/templates/hosts.debian.tmpl
    # the cloud init file says you can set manage_etc_hosts: false
    # to override this but it doesn't work so we add to template
    - text:
      {% for name, ip in salt['pillar.get']('network:hosts', {}).items() %}
      - '{{ ip }} {{ name }}'
      {% endfor %}
    - onlyif: 'test -f /etc/cloud/templates/hosts.debian.tmpl'
{% endif %}