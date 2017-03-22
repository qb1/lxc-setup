#!/bin/bash
DOMAIN=$1

if [ -z "$DOMAIN" ]; then
  echo "Please enter a domain name"
  exit 1
fi

echo "Setup up ubuntu domain $DOMAIN"

mkdir $HOME/$DOMAIN 2> /dev/null

./create_profile.sh $DOMAIN

lxc launch ubuntu:16.04 $DOMAIN -p default -p $DOMAIN

lxc config set $DOMAIN boot.autostart true

# Wait a bit to make sure we have network
sleep 5

lxc exec $DOMAIN -- apt update
lxc exec $DOMAIN -- apt upgrade -y
lxc exec $DOMAIN -- apt install -y xpra xvfb pulseaudio fish
lxc exec $DOMAIN -- chsh $USER -s `which fish`
lxc exec $DOMAIN -- sed -i '/^#.*AuthorizedKeysFile/s/^#//' /etc/ssh/sshd_config

# config fish shell
lxc exec $DOMAIN -- mkdir /home/qbi/.config/fish
lxc exec $DOMAIN -- ln -s /home/qbi/.config/fish_original/config.fish /home/qbi/.config/fish/
lxc exec $DOMAIN -- ln -s /home/qbi/.config/fish_original/functions /home/qbi/.config/fish/
lxc exec $DOMAIN -- chown -R qbi:qbi /home/qbi/.config/fish

./update_hosts.sh $DOMAIN
./push-services.sh $DOMAIN

lxc restart $DOMAIN

sleep 5

ssh $DOMAIN.lxc