#!/bin/bash

name=${1}
timeout=${2}

success_count=0
wait_time=0

while true; do
  ssh -o BatchMode=yes -o ConnectTimeout=1 -F ssh/config -t -q ${name} /etc/kubernetes/ready.sh
  if [ $? -eq 0 ]; then
    if [ ${success_count} -lt 5 ]; then
      echo "${name} success count: ${success_count}"
      ((success_count++))
    else
      echo "${name} is ready, elapsed time: ${wait_time}s"
      exit 0
    fi
  elif [ ${wait_time} -ge ${timeout} ]; then
    echo "echo ${name} is not ready after ${wait_time}s and timeout, exit"
    exit 1
  else
    echo "echo ${name} is not ready after ${wait_time}s, keep waiting..."
  fi
  sleep 1
  ((wait_time++))
done
