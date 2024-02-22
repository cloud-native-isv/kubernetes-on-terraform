#!/bin/bash

# this script run when ecs instance create, will execute only once

echo "# run $0 at $(date '+%Y-%m-%d %H:%M:%S')"

set -x

export cri_socket=/run/containerd/containerd.sock
export ctr_cmd="/usr/bin/ctr -a ${cri_socket}"
export cri_cmd="/usr/bin/crictl -r unix://${cri_socket}"

function k8s_prepare() {
  modprobe bridge
  modprobe br_netfilter
  echo "bridge" >/etc/modules-load.d/k8s_bridge.conf
  echo "br_netfilter" >>/etc/modules-load.d/k8s_bridge.conf

  swapoff -a

  echo "net.bridge.bridge-nf-call-iptables = 1" >>/etc/sysctl.conf
  echo "net.ipv4.ip_forward = 1" >>/etc/sysctl.conf
  echo "fs.inotify.max_user_watches = 1048576" >>/etc/sysctl.conf
  sysctl -p /etc/sysctl.conf

  setenforce 0
  sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

  mkdir -pv /storage/containerd
}

k8s_prepare