#!/bin/bash

DOMAIN=$1

if [ "$DOMAIN" = "work" ]; then
	echo "blue"
elif [ "$DOMAIN" = "personal" ]; then
	echo "yellow"
elif [ "$DOMAIN" = "media" ]; then
	echo "green"
elif [ "$DOMAIN" = "bank" ]; then
	echo "gray"
else
	echo "red"
fi
