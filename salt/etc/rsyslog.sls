
rsyslog_default:
  file.managed:
    - name: /etc/rsyslog.d/50-default.conf
    - source: salt://etc/rsyslog.d/50-default.conf
    - user: root
    - group: root
    - mode: 644

rsyslog:
  service.running:
    - enable: True
    - watch:
      - file: rsyslog_default
