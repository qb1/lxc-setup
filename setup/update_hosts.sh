#!/bin/bash
DOMAIN=$1

if [ -z "$DOMAIN" ]; then
  echo "Please enter a domain name"
  exit 1
fi

HOSTNAME=$DOMAIN.lxc

if ! lxc info $DOMAIN | grep -qs "Status: Running"; then
	echo "Please start the container first"
	exit 1
fi

IP=`lxc info $DOMAIN | grep "10.0.8" | cut -f 3`

TMPFILE=$(mktemp /tmp/hosts.XXXXXX)
grep -v $HOSTNAME /etc/hosts > $TMPFILE
echo "$IP      $HOSTNAME" >> $TMPFILE
sudo mv $TMPFILE /etc/hosts