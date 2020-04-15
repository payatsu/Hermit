#!/bin/sh -l

username=`tail -n 1 /etc/passwd | cut -d: -f1`
[ "${USER}" = "${username}" ] || usermod -l ${USER} -d /home/${USER} -m ${username} || exit
chown  ${USER}:${USER} . || exit
exec runuser -u ${USER} -- "$@"

# vim: set expandtab :
