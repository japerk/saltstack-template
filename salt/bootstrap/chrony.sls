# more secure ntp
chrony_setup:
  pkg.installed:
    - name: chrony
  service.running:
    - name: chrony
    - enable: True
    - require:
      - pkg: chrony