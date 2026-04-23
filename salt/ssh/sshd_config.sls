include:
  - bootstrap.services

sshd_config:
  file.managed:
    - name: /etc/ssh/sshd_config.d/sshd.conf
    - source: salt://ssh/files/sshd.conf
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - makedirs: True
    - watch_in:
      - service: ssh
      