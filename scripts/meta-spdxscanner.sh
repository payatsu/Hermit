#!/bin/sh

: ${codename:=gatesgarth}

main()
{
    if [ ! -f config.project ]; then
        echo "Error: current directory \"`pwd`\" is not a PetaLinux Tools project." >&2
        return 1
    fi

    # put meta-spdxscanner.
    mkdir -p components/ext_sources || return
    if [ ! -d components/ext_sources/meta-spdxscanner ]; then
        git clone -b ${codename} https://git.yoctoproject.org/meta-spdxscanner components/ext_sources/meta-spdxscanner || return
    fi

    if ! grep -e '^CONFIG_USER_LAYER_0=""$' project-spec/configs/config > /dev/null 2>&1;then
        if ! grep -e 'meta-spdxscanner' project-spec/configs/config > /dev/null 2>&1; then
            echo Error: user layer 0 has been already used for another purpose. >&2
            return 1
        fi
    fi

    # edit 'bblayers.conf' indirectly via 'project-spec/configs/config'.
    sed -i -e '
        /^\(CONFIG_USER_LAYER_0=\)""$/{
            s!!\1"${PROOT}/components/ext_sources/meta-spdxscanner"!
            aCONFIG_USER_LAYER_1=""
        }' project-spec/configs/config || return

    # edit 'local.conf' indirectly via 'project-spec/meta-user/conf/petalinuxbsp.conf'.
    if ! grep -e 'fossology' project-spec/meta-user/conf/petalinuxbsp.conf > /dev/null 2>&1; then
        cat << EOF >> project-spec/meta-user/conf/petalinuxbsp.conf || return
# INHERIT += "fossology-rest"
TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE4OTM1NDIzOTksIm5iZiI6MTY0NTgzMzYwMCwianRpIjoiTWk0eiIsInNjb3BlIjoid3JpdGUifQ.5tuqyhLPesHlLA3TAuq3n5wgDhgLSl9PDuopYmBSALE"
FOSSOLOGY_SERVER = "http://192.168.11.15:8081/repo"
# FOLDER_NAME = "xxxx"
EOF
    fi
}

main "$@" || exit

# vim: set expandtab shiftwidth=0 tabstop=4 :
