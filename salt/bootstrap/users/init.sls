
root_aliases:
  file.managed:
    - name: /root/.bash_aliases
    - source: salt://bootstrap/files/bash_aliases
    - mode: 644
    - template: jinja
    - user: root

root_vimrc:
  file.managed:
    - name: /root/.vimrc
    - source: salt://bootstrap/files/vimrc
    - mode: 644
    - user: root