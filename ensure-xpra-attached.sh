#!/bin/bash

DOMAIN=$1

if [ -z "$DOMAIN" ]; then
  echo "Please enter a domain name"
  exit 1
fi

HOSTNAME=$DOMAIN.lxc

if ! ps aux | grep "xpra attach" | grep -qs $HOSTNAME; then
	lxc start $DOMAIN
	until ping -c1 $HOSTNAME &>/dev/null; do :; done
	xpra attach tcp:$HOSTNAME:10000 --tray=no --border=`~/tools/lxc/domain-color.sh $DOMAIN`  --opengl=yes --encoding=rgb &
fi