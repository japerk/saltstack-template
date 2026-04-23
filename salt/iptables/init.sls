
{% set ssh_port = salt['pillar.get']('ssh:port', 'ssh') %}
{% set ssh_rule = "-p tcp -j ACCEPT --dport " ~ ssh_port %}
{% set rsyslog_accept_rule = "-p udp --dport 514 -j ACCEPT -s 127.0.0.1" %}
{% set rsyslog_drop_rule = "-p udp --dport 514 -j DROP" %}

iptables_ssh:
  cmd.run:
    - name: "iptables -I INPUT 1 {{ ssh_rule }}"
    # unless triggers cmd on fail, -C returns False if rule does not exist
    - unless: "iptables -C INPUT {{ ssh_rule }}"
    - watch_in:
      - cmd: save_iptables

iptables_rsyslog_accept:
  cmd.run:
    - name: "iptables -I INPUT 2 {{ rsyslog_accept_rule }}"
    - unless: "iptables -C INPUT {{ rsyslog_accept_rule }}"
    - watch_in:
      - cmd: save_iptables

iptables_rsyslog_drop:
  cmd.run:
    - name: "iptables -A INPUT {{ rsyslog_drop_rule }}"
    - unless: "iptables -C INPUT {{ rsyslog_drop_rule }}"
    - watch_in:
      - cmd: save_iptables

iptables-persistent:
  pkg.installed:
    - allow_updates: True
  require:
    - cmd: iptables_ssh

save_iptables:
  require:
    - pkg: iptables-persistent
  cmd.wait:
    - name: 'iptables-save -c > /etc/iptables/rules.v4'

# if ufw is enabled, iptables rules above get flushed
ufw_disable:
  file.replace:
    - name: /etc/ufw/ufw.conf
    - pattern: 'ENABLED=yes'
    - repl: 'ENABLED=no'
    - ignore_if_missing: True