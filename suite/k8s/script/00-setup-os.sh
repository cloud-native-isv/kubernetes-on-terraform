#!/bin/bash

# this script run when ecs instance start, will execute multiple times

echo "# run $0 at $(date '+%Y-%m-%d %H:%M:%S')"

set -x

function install_basic() {
  yum install -y \
    bash \
    bc \
    bzip2 \
    ca-certificates \
    curl \
    file \
    findutils \
    gawk \
    gettext \
    git \
    gzip \
    hostname \
    iproute-tc \
    jq \
    lz4 \
    make \
    openssh-clients \
    openssl \
    sudo \
    tar \
    unzip \
    vim \
    wget \
    xz
}
function setup_sshd() {
  echo "PermitRootLogin yes" >>/etc/ssh/sshd_config
  echo "Port 10022" >>/etc/ssh/sshd_config
  systemctl restart sshd
}

function setup_python() {
  yum install -y python38 python38-setuptools python38-pip
  alternatives --set python3 /usr/bin/python3.8
}

function setup_storage() {
  mkfs.ext4 -F -b 4096 /dev/vdb
  mkdir -pv /storage
  mount /dev/vdb /storage
  echo '/dev/vdb /storage ext4 defaults 0 0' >>/etc/fstab
}

function enable_iommu() {
  grubby --update-kernel=ALL --args="intel_iommu=on iommu=pt"
  grub2-mkconfig -o /boot/grub2/grub.cfg
}


install_basic
setup_sshd
setup_python
setup_storage

enable_iommu

