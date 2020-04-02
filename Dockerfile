ARG USER=developer
ARG install_dir=/opt/petalinux
ARG installer=petalinux-v2019.2-final-installer.run
ARG baseimage=ubuntu:18.04

FROM ${baseimage} AS petalinux-base
ARG USER
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
zlib1g-dev \
zlib1g:i386 \
&& \
apt-get autoremove -y && apt-get autoclean -y && rm -vr /var/lib/apt/lists/* && \
sed -i -e 's/^# \(en_US\.UTF-8 UTF-8\)$/\1/' /etc/locale.gen && \
sed -i -e 's/^# \(ja_JP\.UTF-8 UTF-8\)$/\1/' /etc/locale.gen && \
locale-gen && \
groupadd ${USER} && \
useradd -g ${USER} -m -s /bin/bash ${USER} && \
echo root:root | chpasswd && \
echo ${USER}:${USER} | chpasswd && \
mkdir -pv ${install_dir} && \
chown -Rv ${USER}:${USER} ${install_dir}
USER ${USER}

FROM petalinux-base AS petalinux-builder
ARG USER
ARG install_dir
ARG installer

COPY --chown=${USER}:${USER} ${installer} /tmp
RUN \
chmod a+x /tmp/${installer} && \
(cd /tmp; yes | ./${installer} ${install_dir})

FROM petalinux-base
ARG USER
ARG install_dir

COPY --from=petalinux-builder ${install_dir} ${install_dir}
WORKDIR /home/${USER}
ENV LANG=ja_JP.utf8 SHELL=/bin/bash USER=${USER}
