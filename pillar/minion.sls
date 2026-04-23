{% set hostname = 'MINION_NAME' %}
{% set localhost = '127.0.0.1' %}

network:
  public_iface: eth0
  private_iface: lo
  hostname: {{ hostname }}
  hosts:
    MINION_NAME: {{ localhost }}
    {{ hostname }}: {{ localhost }}

salt:
  master_ip: {{ localhost }}

# systemd-resolved drop-in (etc.dns). Per-host: systemd_resolved.dns_extra for ISP resolvers.
systemd_resolved:
  dns:
    - 8.8.8.8
    - 9.9.9.9
  fallback_dns:
    - 1.1.1.1
    - 1.0.0.1
