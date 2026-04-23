{%- set hostname = salt['pillar.get']('network:hostname') %}
{%- set ip = salt['network.interface_ip'](salt['pillar.get']('network:public_iface')) %}
{% if hostname and ip %}
hostname:
# NOTE: network.system fails trying to set hostname
  file.managed:
    - name: /etc/hostname
    - contents: {{ hostname }}
  cmd.wait:
    - name: hostname {{ hostname }}
    - watch:
      - file: hostname
  host.present:
    - ip: {{ ip }}
    - names:
      - {{ hostname }}
hostname_debian_tmpl:
  file.append:
    - name: /etc/cloud/templates/hosts.debian.tmpl
    # the cloud init file says you can set manage_etc_hosts: false
    # to override this but it doesn't work so we add to template
    - text: '{{ ip }} {{ hostname }} {{ hostname }}'
    - onlyif:
      - 'test -f /etc/cloud/templates/hosts.debian.tmpl'
{%- endif %}
