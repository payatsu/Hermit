#!/bin/bash -l

# set trap that invokes new `bash` with root permission whenever an error occurs.
# errors are expected to cause `exit`(see below).
trap bash EXIT

[ -n "${DEBUG_ENTRYPOINT}" ] && set -x

username=`tail -n 1 /etc/passwd | cut -d: -f1`
if [ "${USER}" != "${username}" ]; then
    usermod -l ${USER} ${username} || exit
    cp -Tr /etc/skel /home/${USER} || exit
fi

groupname=`tail -n 1 /etc/group | cut -d: -f1`
if [ "${USER}" != "${groupname}" ]; then
    groupmod -n ${USER} ${groupname} || exit
fi

chown  ${USER}:${USER} . || exit

# the `bash` process running this script never EXIT(`exit` successfully),
# because it does `exec` here.
exec runuser -u ${USER} -- "$@"

# vim: set expandtab :
