unattended_upgrades:
  file.managed:
    - name: /etc/apt/apt.conf.d/50unattended-upgrades
    - source: salt://etc/apt.conf.d/50unattended-upgrades
    - mode: 644
    - template: jinja
    - user: root
    - group: root

auto_upgrades:
  file.managed:
    - name: /etc/apt/apt.conf.d/20auto-upgrades
    - source: salt://etc/apt.conf.d/20auto-upgrades
    - mode: 644
    - template: jinja
    - user: root
    - group: root
    - require:
      - file: unattended_upgrades