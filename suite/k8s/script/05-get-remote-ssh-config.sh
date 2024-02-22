#!/bin/bash

name=${1}
public_ip=${2}

echo "${name}" >>remote/remote_hosts

cat <<EOF >>ssh/config
Host ${name}
    Hostname ${public_ip}
EOF

cat <<EOF >>remote.rc

function ssh_${name}() {
    ssh -F ssh/config ${name} \$@;
}

EOF
