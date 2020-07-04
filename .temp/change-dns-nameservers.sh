#!/bin/bash

systemd-resolve --status

# To change DNS (some of these may not be necessary):
# 1. Change /etc/resolv.conf
# 2. Change /etc/netplan/01-netcfg.yaml
# 3. Change /etc/network/interfaces
# 4. Run `sudo netplan apply`

# Other places to check:
# /etc/resolvconf/resolv.conf.d/head
# /etc/resolvconf/resolv.conf.d/base
