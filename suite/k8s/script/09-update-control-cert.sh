#!/bin/bash

name=${1}
private_ip=${2}
public_ip=${3}

ssh -F ssh/config -t -q ${name} << EOT
cat << EOF > /etc/kubernetes/update_cert.sed
/apiServer:/a \\
\\ \\ certSANs:\n\\
\\ \\ - ${private_ip}\n\\
\\ \\ - ${public_ip}
EOF

kubectl -n kube-system get configmap kubeadm-config -o jsonpath='{.data.ClusterConfiguration}' > /etc/kubernetes/kubeadm-config.yaml
sed -i -f /etc/kubernetes/update_cert.sed /etc/kubernetes/kubeadm-config.yaml

mv -fv /etc/kubernetes/pki/apiserver.crt /etc/kubernetes/pki/apiserver.crt.bak
mv -fv /etc/kubernetes/pki/apiserver.key /etc/kubernetes/pki/apiserver.key.bak

kubeadm init phase certs apiserver --v=5 --config /etc/kubernetes/kubeadm-config.yaml
EOT

