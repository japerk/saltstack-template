
packages_generic:
  pkg.installed:
    - allow_updates: True
    - pkgs:
      - ack
      - aptitude
      - apt-transport-https
      - build-essential
      - bzip2
      - htop
      - openssh-server
      - openssh-client
      - tmux
      - vim
      - libcrypto++-dev
      - libpcre3-dev
      - libssl-dev
      - libffi-dev
      - libzmq5
      - net-tools
      - socat
      - software-properties-common
      - sysfsutils
      - sysstat

packages_python_generic:
  pkg.installed:
    - allow_updates: True
    - pkgs:
      - python3
      - python3-dev
      - python3-pip
      - python3-zmq
      - python3-virtualenv