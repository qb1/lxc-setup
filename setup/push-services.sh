#!/bin/bash

lxc exec $1 -- mkdir /etc/conf.d/
lxc file push xpra $1/etc/conf.d/xpra
lxc exec $1 -- chown root:root /etc/conf.d/xpra
lxc file push xpra.service $1/etc/systemd/system/xpra.service
lxc exec $1 -- chown root:root /etc/systemd/system/xpra.service
lxc exec $1 -- chmod +x /etc/systemd/system/xpra.service
lxc exec $1 -- systemctl enable xpra.service