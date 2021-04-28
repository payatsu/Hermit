#!/bin/bash -l

[ -n "${TRACE_ENTRYPOINT}" ] && set -x

# set trap that invokes new `bash` with root permission whenever an error occurs.
# errors are expected to cause `exit`(see below).
trap atexit EXIT

atexit()
{
    echo shell/environment variables: >&2
    set >&2
    echo >&2

    echo environment variables: >&2
    env >&2
    echo >&2

    bash
}

[ -n "${INTERACTIVE_ENTRYPOINT}" ] && exit

[ -n "${USER}" ] || { echo USER is empty >&2; exit;}

username=`grep -e '^[^:]\+:[^:]\+:1000:' /etc/passwd | cut -d: -f1`
if [ "${USER}" != "${username}" ]; then
    usermod -l ${USER} -d /home/${USER} ${username} || exit
fi

groupname=`grep -e '^[^:]\+:[^:]\+:1000:' /etc/group | cut -d: -f1`
if [ "${USER}" != "${groupname}" ]; then
    groupmod -n ${USER} ${groupname} || exit
fi

chown ${USER}:${USER} /home/${USER} || exit
[ -f /home/${USER}/.profile ] || find /etc/skel -type f -exec install -o ${USER} -g ${USER} -m 644 -t /home/${USER} {} + || exit

chown ${USER} `tty` || exit

# the `bash` process running this script never EXIT(`exit` successfully),
# because it does `exec` here.
exec runuser -u ${USER} -- "$@"

# vim: set expandtab :
