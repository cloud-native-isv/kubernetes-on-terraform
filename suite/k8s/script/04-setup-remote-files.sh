#!/bin/bash

prefix=${1}
public_key_file=${2}

rm -rfv kube remote ssh remote.rc
mkdir -pv kube/manifest remote ssh
echo "export REMOTE_HOSTS_FILE=${PWD}/remote/remote_hosts" >remote.rc
echo "export SSH_CONFIG_FILE=${PWD}/ssh/config" >>remote.rc
echo "export KUBECONFIG=${PWD}/kube/config.yaml" >>remote.rc

cat <<'EOF' >>remote.rc

if [ -n "${BASH_VERSION}" ]; then
  DIR=$(dirname "${BASH_SOURCE[0]}")
  if [ "${DIR}" == "." ]; then
    DIR=$(pwd)
  fi

  ROOT=$(readlink -f ${DIR})
  cd ${ROOT}
fi

EOF

cat <<EOF >ssh/config
Host *
  ServerAliveInterval 5
  ExitOnForwardFailure yes
  ForwardAgent yes
  IdentityFile ~/.ssh/id_rsa
  PubkeyAcceptedAlgorithms +ssh-rsa
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  ConnectTimeout 10
  
Host jumper-for-k8s
  Hostname 121.196.208.106
  Port 10022
  User jumper

Host ${prefix}*
  Port 10022
  User root
  ProxyJump jumper-for-k8s
  IdentityFile $(echo ${public_key_file} | sed 's/\.pub$//g')
EOF

