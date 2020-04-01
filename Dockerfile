FROM ubuntu:18.04
ARG USER=builder
ARG installer=petalinux-v2019.2-final-installer.run

RUN \
echo no | dpkg-reconfigure dash && \
dpkg --add-architecture i386 && \
apt-get update && apt-get upgrade -y && \
echo Asia/Tokyo > /etc/timezone && \
DEBIAN_FRONTEND=noninteractive \
apt-get install -y --no-install-recommends tzdata locales && \
apt-get install -y --no-install-recommends \
autoconf \
bison \
build-essential \
chrpath \
cpio \
diffstat \
flex \
gawk \
gcc-multilib \
git-core \
gnupg \
iproute2 \
less \
libncurses5-dev \
libselinux1 \
libssl-dev \
libtool \
net-tools \
python \
socat \
texinfo \
tofrodos \
unzip \
wget \
xterm \
zlib1g-dev \
zlib1g:i386 \
&& \
apt-get autoremove -y && apt-get autoclean -y && rm -vr /var/lib/apt/lists/* && \
groupadd ${USER} && \
useradd -g ${USER} -m -s /usr/bin/bash ${USER} && \
echo root:root | chpasswd && \
echo ${USER}:${USER} | chpasswd && \
sed -i -e 's/^# \(en_US\.UTF-8 UTF-8\)$/\1/' /etc/locale.gen && \
sed -i -e 's/^# \(ja_JP\.UTF-8 UTF-8\)$/\1/' /etc/locale.gen && \
locale-gen && \
mkdir -pv /opt/petalinux && \
chown -Rv ${USER}:${USER} /opt/petalinux
USER ${USER}
WORKDIR /home/${USER}
ENV LANG=ja_JP.utf8 SHELL=/usr/bin/bash USER=${USER}
COPY ${installer} /home/${USER}/${installer}
RUN \
./${installer} --skip_license
