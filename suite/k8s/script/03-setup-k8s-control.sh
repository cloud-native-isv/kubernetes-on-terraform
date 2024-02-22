#!/bin/bash

# this script run when ecs instance create, will execute only once

echo "# run $0 at $(date '+%Y-%m-%d %H:%M:%S')"

set -x

export K8S_REPOSITORY="registry.cn-hangzhou.aliyuncs.com/google_containers"
export K8S_POD_CIDR="10.244.0.0/16"

function k8s_restart_service() {
  systemctl restart containerd
  systemctl restart kubelet
}

function k8s_init() {
  local image_repository="--image-repository ${K8S_REPOSITORY}"

  kubeadm config --v=5 \
    --kubernetes-version ${k8s_version} \
    ${image_repository} images pull
  kubeadm init --v=5 \
    --kubernetes-version ${k8s_version} \
    --cri-socket=unix://${cri_socket} \
    --pod-network-cidr=${K8S_POD_CIDR} \
    ${image_repository}
  wait
  mkdir -pv ~/.kube
  cp -fv /etc/kubernetes/admin.conf ~/.kube/config
  chown $(id -u):$(id -g) ~/.kube/config
}

function k8s_join_command() {
  kubeadm token create --print-join-command >/etc/kubernetes/join-command.sh
}

function k8s_notice_ready() {
  cat <<EOF >/etc/kubernetes/ready.sh
#!/bin/bash
if command -v cloud-init; then
  cloud-init status --wait
fi
echo "k8s is ready."
EOF
  chmod a+x /etc/kubernetes/ready.sh
}

k8s_restart_service
k8s_init
k8s_join_command
k8s_notice_ready