
#!/bin/bash

# this script run when ecs instance create, will execute only once

echo "# run $0 at $(date '+%Y-%m-%d %H:%M:%S')"

set -x

export k8s_version=1.28.2
export cri_version=1.26.0
export docker_version=20.10.17 # this version of docker has buildkit with squash
export containerd_version=1.6.24

function k8s_setup_repo() {
  cat >/etc/yum.repos.d/k8s.repo <<'EOF'
[kubernetes]
name=kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
[docker]
name=docker
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/8/x86_64/stable
enabled=1
gpgcheck=0
EOF
}

function k8s_insall_rpms() {
  yum install -y $@ \
    containerd.io-${containerd_version}
  systemctl enable containerd

  yum install -y $@ \
    kubeadm-${k8s_version} \
    kubelet-${k8s_version} \
    kubectl-${k8s_version} \
    cri-tools-${cri_version} \
    libcgroup-tools
  systemctl enable kubelet
}

k8s_setup_repo
k8s_insall_rpms