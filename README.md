lxc-setup
=========

This is a bunch of scripts to help managing lxd containers as domains (sort ala QubesOS, but much less secure).

The basic idea is:
 * domains are ubuntu containers
 * full connectivity by default
 * uses xpra for X forwarding through raw TCP
 * shares host pulseaudio through TCP as well

No doubt security is questionable, but it helps separation of concerns.

The setup directory help setting up basic ubuntu LTS containers with necessary packages to allow X sharing via xpra.

Scripts at root are for basic usage, most notably you can use `start-lxc-xpra.sh <domain> <program>`.

This probably needs quite some more work to be usable, but it suits my needs