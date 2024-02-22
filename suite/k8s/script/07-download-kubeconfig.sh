#!/bin/bash

private_ip=${1}
public_ip=${2}

mkdir -pv kube
scp -F ssh/config -r k8s-control:/etc/kubernetes/admin.conf kube/config.yaml
scp -F ssh/config -r k8s-control:/etc/kubernetes/join-command.sh kube/join-command.sh

sed -i "s/${private_ip}/${public_ip}/g" kube/config.yaml