#!/bin/bash

# this script run when ecs instance create, will execute only once

echo "# run $0 at $(date '+%Y-%m-%d %H:%M:%S')"

set -x

function k8s_restart_service() {
  systemctl restart containerd
  systemctl restart kubelet
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
k8s_notice_ready
