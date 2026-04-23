f2ban_pkg:
  pkg.installed:
    - name: fail2ban
    - allow_update: True

f2ban_service:
  service.running:
    - name: fail2ban
    - enable: True
    - require:
      - pkg: f2ban_pkg

f2ban_debian_jail_conf:
  file.managed:
    - name: /etc/fail2ban/jail.d/defaults-debian.conf
    - source: salt://etc/fail2ban/defaults-debian.conf
    - mode: 644
    - user: root
    - group: root
    - require:
      - pkg: f2ban_pkg
    - watch_in:
      - service: f2ban_service

f2ban_jail:
  file.managed:
    - name: /etc/fail2ban/jail.local
    - source: salt://etc/fail2ban/jail.local
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - require:
      - pkg: f2ban_pkg
    - watch_in:
      - service: f2ban_service