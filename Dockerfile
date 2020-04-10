ARG install_dir=/opt/petalinux
ARG baseimage=ubuntu:18.04

FROM ${baseimage} AS petalinux-yorishiro
ARG USER=developer
ENV USER=${USER}
ARG install_dir

RUN \
echo no | dpkg-reconfigure dash && \
dpkg --add-architecture i386 && \
apt-get update && apt-get upgrade -y && \
echo Asia/Tokyo > /etc/timezone && \
DEBIAN_FRONTEND=noninteractive \
apt-get install -y --no-install-recommends tzdata locales && \
apt-get install -y --no-install-recommends \
autoconf \
automake \
bc \
bison \
build-essential \
chrpath \
cpio \
diffstat \
flex \
gawk \
gcc-multilib \
git \
gnupg \
iproute2 \
libc6-dev:i386 \
libglib2.0-dev \
libncurses5-dev \
libsdl1.2-dev \
libselinux1 \
libssl-dev \
libtool \
libtool-bin \
lsb-release \
net-tools \
pax \
python \
rsync \
screen \
socat \
texinfo \
tftpd \
tofrodos \
u-boot-tools \
update-inetd \
unzip \
wget \
xterm \
xvfb \
xxd \
zlib1g-dev \
zlib1g:i386 \
&& \
apt-get autoremove -y && apt-get autoclean -y && rm -vr /var/lib/apt/lists/* && \
sed -i -e 's/^# \(en_US\.UTF-8 UTF-8\)$/\1/' /etc/locale.gen && \
sed -i -e 's/^# \(ja_JP\.UTF-8 UTF-8\)$/\1/' /etc/locale.gen && \
locale-gen && \
echo "[ -f ${install_dir}/settings.sh ] && . ${install_dir}/settings.sh" >> /etc/bash.bashrc && \
groupadd ${USER} && \
useradd -g ${USER} -m -s /bin/bash ${USER} && \
echo root:root | chpasswd && \
echo ${USER}:${USER} | chpasswd && \
mkdir -pv ${install_dir} && \
chown -Rv ${USER}:${USER} ${install_dir}
USER ${USER}

FROM petalinux-yorishiro AS petalinux-sacrifice
ARG install_dir

RUN \
installer=petalinux-v${PETALINUX_VER:-2019.2}-final-installer.run; \
wget --progress=dot:giga -P /tmp http://repository/${installer} && \
chmod a+x /tmp/${installer} && \
(cd /tmp; yes | ./${installer} ${install_dir}) && \
rm -fv /tmp/${installer}

FROM petalinux-sacrifice AS petalinux-zombie
ARG install_dir

RUN \
find ${install_dir}/components/yocto/source -type d -name '*microblaze*' -prune -exec sh -c 'echo removing {}; rm -fr {}' \; && \
rm -fvr ${install_dir}/components/yocto/downloads

FROM petalinux-yorishiro AS petalinux-slim
ARG install_dir

COPY --from=petalinux-zombie ${install_dir} ${install_dir}
WORKDIR /home/${USER}
ENV LANG=ja_JP.utf8 SHELL=/bin/bash
