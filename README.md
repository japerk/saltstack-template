1. Copy this repo
2. Find & replace all instances of MINION_NAME
3. Replace `root` in `rsync.sh` with your preferred user

---

# Key features of this template

- Opinionated Salt orchestration in `salt/top.sls`:
  - `bootstrap`
  - `etc`
  - `iptables.salt_master`
  - `ssh`
- Bootstrap baseline:
  - common system and Python packages
  - `chrony` + UTC timezone
  - SSH service enabled
  - root shell/Vim defaults (`.bash_aliases`, `.vimrc`)
- Security hardening:
  - fail2ban with SSH jail
  - SSH config management in `/etc/ssh/sshd_config.d/sshd.conf`
  - iptables rules for SSH + rsyslog UDP handling
  - persistent firewall rules via `iptables-persistent`
  - UFW disable guard to prevent rule flush conflicts
- Ops hygiene:
  - unattended upgrades + auto-upgrades
  - rsyslog config management
  - logrotate policies for rsyslog/supervisor plus optional pillar extras
  - swap file provisioning (`/mnt/swap`)
- Pillar-driven host/network setup:
  - hostname and `/etc/hosts` management
  - easy customization of SSH/network values per host

# Salt Setup

As `root` do the following:

1. `curl -fsSL https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public | sudo tee /etc/apt/keyrings/salt-keyring.pgp`
2. `echo "deb [signed-by=/etc/apt/keyrings/salt-keyring.pgp arch=amd64] https://packages.broadcom.com/artifactory/saltproject-deb/ stable main" | sudo tee /etc/apt/sources.list.d/salt.list`
3. `apt update`
4. `apt install salt-master salt-minion`
5. `echo "interface: 127.0.0.1" > /etc/salt/master.d/master.conf`
6. `systemctl enable salt-master && sudo systemctl start salt-master`
7. `vim /etc/salt/minion.d/minion.conf`
``` yaml
hash_type: sha256
id: MINION_NAME
log_level: info
master: 127.0.0.1
```
8. `systemctl enable salt-minion && sudo systemctl start salt-minion`
9. `salt-key -A`
10. Create/update pillar file & `./rsync.sh`
11. `salt MINION_NAME state.sls bootstrap`
12. `salt MINION_NAME state.highstate`
13. `salt MINION_NAME pkg.refresh_db`
14. `salt MINION_NAME pkg.upgrade`
15. `salt MINION_NAME shadow.lock_password root`
16. `reboot`

---

# Common pillar updates before first run

When you get to step 10 (`Create/update pillar file & ./rsync.sh`), these are the most common values to set in `pillar/minion.sls`:

- `network:public_iface`: set to your host's public interface (for example `ens3` instead of default `eth0`)
- `network:private_iface`: set if you use a dedicated private interface, otherwise keep `lo`
- `network:hostname`: your real machine hostname
- `network:hosts`: add host-to-IP mappings used by `/etc/hosts` and Salt firewall allow rules
- `salt:master_ip`: set explicitly if Salt master traffic should bind/route via a non-default address
- `ssh:port`: change from `22` if you run SSH on a custom port
- `ssh:listen_address`: restrict SSH bind address as needed (default is `0.0.0.0`)
- `ssh:allow_users`: add allowed SSH users beyond the default template user
- `etc:logrotate`: optional list of extra files in `salt/etc/logrotate.d/` to deploy

Example starter shape:

```yaml
network:
  public_iface: ens3
  private_iface: lo
  hostname: my-host
  hosts:
    my-host: 127.0.0.1
    app-1: 10.0.0.11

salt:
  master_ip: 127.0.0.1

ssh:
  port: 22
  listen_address: 0.0.0.0
  allow_users:
    - deploy

etc:
  logrotate: []
```