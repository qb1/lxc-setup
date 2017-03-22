#!/bin/bash

DOMAIN=$1
shift
CMD=$*

if [ -z "$DOMAIN" ]; then
  echo "Please enter a domain name"
  exit 1
fi

if [ -z "$CMD" ]; then
  echo "Please enter a command"
  exit 1
fi

echo "Starting '$CMD' on $DOMAIN..."

HOSTNAME=$DOMAIN.lxc

~/tools/lxc/ensure-xpra-attached.sh $DOMAIN

xpra control tcp:$HOSTNAME:10000 start-child "$CMD"