include:
  - iptables

{% set network = salt['pillar.get']('network') %}
{% set master_ip = salt['pillar.get']('salt:master_ip') or network.get(network.get('private_iface')) or '0.0.0.0' %}
{% for port in ['4505', '4506'] %}
{% set drop_rule = "-p tcp -j DROP -d " ~ master_ip ~ " --dport " ~ port  %}

{% for host, ip in network.get('hosts', {}).items() %}
{% if ip != '127.0.0.1' %}
{% set accept_rule = "-p tcp -j ACCEPT -s " ~ ip ~ " -d " ~ master_ip ~ " --dport " ~ port ~ " -m comment --comment " ~ host %}
iptables_salt_accept_{{ host }}_{{ port }}:
  cmd.run:
    - name: "iptables -I INPUT 2 {{ accept_rule }}"
    - unless: "iptables -C INPUT {{ accept_rule }}"
    - watch_in:
      - cmd: save_iptables
    - require_in:
      - cmd: iptables_salt_drop_4505
      - cmd: iptables_salt_drop_4506
{% endif %}
{% endfor %}

{% if master_ip != '127.0.0.1' %}
{% set ips = ['127.0.0.1', master_ip] %}
{% else %}
{% set ips = ['127.0.0.1'] %}
{% endif %}

{% for ip in ips %}
{% set accept_rule = "-p tcp -j ACCEPT -s " ~ ip ~ " -d " ~ master_ip ~ " --dport " ~ port ~ " -m comment --comment localhost" %}
iptables_salt_accept_{{ ip }}_{{ port }}:
  cmd.run:
    - name: "iptables -I INPUT 2 {{ accept_rule }}"
    - unless: "iptables -C INPUT {{ accept_rule }}"
    - watch_in:
      - cmd: save_iptables
    - require_in:
      - cmd: iptables_salt_drop_4505
      - cmd: iptables_salt_drop_4506
{% endfor %}

{% set drop_rule = "-p tcp -j DROP -d " ~ master_ip ~ " --dport " ~ port  %}
iptables_salt_drop_{{ port }}:
  cmd.run:
    - name: "iptables -A INPUT {{ drop_rule }}"
    - unless: "iptables -C INPUT {{ drop_rule }}"
    - watch_in:
      - cmd: save_iptables
{% endfor %}