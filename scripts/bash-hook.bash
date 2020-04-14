#!/bin/bash

if [ `whoami` = root ]; then
    if [ ! -f /bin/bash.orig ]; then
        mv -v /bin/bash /bin/bash.orig || exit
        sed -e '1s/bash/bash.orig/' ${0} > /bin/bash || exit
        chmod -v a+x /bin/bash || exit
    fi
    exit
fi

save_script()
{
    while getopts c: arg; do
        case ${arg} in
        c)
            if [ `echo "${OPTARG}" | wc -l` -gt 1 ]; then
                shift `expr ${OPTIND} - 1`
                echo "${OPTARG}" | sed -e 's/^\(\#\{78\}\)\#\+$/\1/' > /tmp/${1}
            fi
            ;;
        esac
    done
}

save_script "$@"

exec /bin/bash.orig "$@"

# vim: set expandtab :
