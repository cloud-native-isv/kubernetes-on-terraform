#!/bin/bash 

name=${1}

scp -F ssh/config -r kube/join-command.sh ${name}:/etc/kubernetes/join-command.sh;
ssh -F ssh/config -t -q ${name} -- bash /etc/kubernetes/join-command.sh;