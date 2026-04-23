{% for fname in ['rsyslog', 'supervisor'] %}
logrotate_{{ fname }}:
  file.managed:
    - name: /etc/logrotate.d/{{ fname }}
    - source: salt://etc/logrotate.d/{{ fname }}
    - template: jinja
    - user: root
    - group: root
    - mode: 644
{% endfor %}

{% for fname in salt['pillar.get']('etc:logrotate', []) %}
logrotate_{{ fname }}:
  file.managed:
    - name: /etc/logrotate.d/{{ fname }}
    - source: salt://etc/logrotate.d/{{ fname }}
    - template: jinja
    - user: root
    - group: root
    - mode: 644
{% endfor %}
