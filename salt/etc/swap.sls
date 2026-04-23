# based on https://www.cyberciti.biz/faq/linux-add-a-swap-file-howto/
{% set swapfile="/mnt/swap" %}

dd_swap:
  cmd.run: # 1GB swap file
    - name: "dd if=/dev/zero of={{ swapfile }} bs=1024 count=1048576"
    - creates: {{ swapfile }}
    - user: root
    - group: root

mkswap:
  cmd.wait:
    - name: "mkswap {{ swapfile }}"
    - user: root
    - group: root
    - watch:
      - cmd: dd_swap
# this automatically adds to fstab
mount_swap:
  mount.swap:
    - name: {{ swapfile }}
    - watch:
      - cmd: mkswap

swap_img_absent:
  module.run:
    - mount.swapoff:
      - name: /swap.img
    - onlyif: 'test -f /swap.img'
  #mount.fstab_absent: this doesn't work
  file.absent:
    - name: /swap.img
    - require:
      - module: swap_img_absent