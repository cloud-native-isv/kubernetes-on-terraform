#!/bin/bash

set -x

function net_my_ip() {
  if curl -s --connect-timeout 120 https://cip.cc | grep -E '^IP' | awk '{print $NF}'; then
    return 1
  fi

  local ip_apis=$(
    cat <<EOF
https://api.seeip.org
https://api.ipify.org
EOF
  )
  for url in ${ip_apis}; do
    if curl -s --connect-timeout 120 ${url}; then
      return 0
    fi
  done
  return 1
}

ip=$(net_my_ip)
network=$(echo ${ip} | sed -E 's@(.*)\.[0-9]+$@\1.0/24@g')
echo "{\"network\": \"${network}\"}"
