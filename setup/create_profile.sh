#!/bin/bash
DOMAIN=$1

if [ -z "$DOMAIN" ]; then
  echo "Please enter a domain name"
  exit 1
fi

echo "Creating profile for domain $DOMAIN"

mkdir $HOME/$DOMAIN 2> /dev/null

set -eu
_UID=$(id -u)
GID=$(id -g)

# give lxd permission to map your user/group id through
grep root:$_UID:1 /etc/subuid -qs || sudo usermod --add-subuids ${_UID}-${_UID} --add-subgids ${GID}-${GID} root

# set up a separate key to make sure we can log in automatically via ssh
# with $HOME mounted
KEY=$HOME/.ssh/id_lxd_$USER
PUBKEY=$KEY.pub
AUTHORIZED_KEYS=$HOME/$DOMAIN/.ssh/authorized_keys
[ -f $PUBKEY ] || ssh-keygen -f $KEY -N '' -C "key for local lxds"
mkdir -p $HOME/$DOMAIN/.ssh
grep "$(cat $PUBKEY)" $AUTHORIZED_KEYS -qs || cat $PUBKEY >> $AUTHORIZED_KEYS

# create a profile to control this, name it after $USER
lxc profile create $DOMAIN &> /dev/null || true

# configure profile
# this will rewrite the whole profile
cat << EOF | lxc profile edit "$DOMAIN"
name: $USER
description: allow home dir mounting for $USER
config:
  # this part maps uid/gid on the host to the same on the container
  raw.idmap: |
    uid $_UID $_UID
    gid $GID $GID
  user.vendor-data: |
    #cloud-config
    users:
      - name: $USER
        groups: sudo
        shell: $SHELL
        sudo: ['ALL=(ALL) NOPASSWD:ALL']
# this section adds your \$HOME directory into the container. This is useful for vim, bash and ssh config, and such like.
devices:
  home:
    type: disk
    source: $HOME/$DOMAIN
    path: $HOME
  conffish:
    type: disk
    source: $HOME/.config/fish
    path: $HOME/.config/fish_original
    readonly: true
EOF


# to launch a container using this profile:
# lxc launch ubuntu: -p default -p $USER

# to add an additional bind mount
# lxc config device add <container> <device name> disk source=/path/on/host path=path/in/container