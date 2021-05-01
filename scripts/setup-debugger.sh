#!/bin/sh

if [ `whoami` = root ]; then
	apt-get update || exit
	apt-get install -y --no-install-recommends gdb strace file || exit
	# apt-get install -y --no-install-recommends binutils

	apt-get install -y --no-install-recommends lsb-release || exit
	printf "deb http://ddebs.ubuntu.com %s main restricted universe multiverse\n" $(lsb_release -cs)          >  /etc/apt/sources.list.d/ddebs.list || exit
	printf "deb http://ddebs.ubuntu.com %s main restricted universe multiverse\n" $(lsb_release -cs)-updates  >> /etc/apt/sources.list.d/ddebs.list || exit
# printf "deb http://ddebs.ubuntu.com %s main restricted universe multiverse\n" $(lsb_release -cs)-security >> /etc/apt/sources.list.d/ddebs.list || exit
	printf "deb http://ddebs.ubuntu.com %s main restricted universe multiverse\n" $(lsb_release -cs)-proposed >> /etc/apt/sources.list.d/ddebs.list || exit
	apt-get install -y --no-install-recommends gnupg || exit
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 428D7C01 C8CAB6595FDFF622 || exit

	apt-get update || exit
fi

exit 0
