1. Copy this repo
2. Find & replace all instances of MINION_NAME
3. Replace `root` in `rsync.sh` with your preferred user

---

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