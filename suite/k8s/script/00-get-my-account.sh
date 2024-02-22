#!/bin/bash

set -x

function aliyun_account_discover () 
{ 
    local root=${1:-${PWD}};
    if [ "${root}" != "/" ]; then
        local account=$(basename ${root});
        local root=$(dirname ${root});
        if [[ "${account}" =~ ^1[0-9]{15}$ ]]; then
            echo ${account};
            return  0;
        else
            aliyun_account_discover ${root};
        fi;
    fi
}

account=$(aliyun_account_discover)
echo "{\"account\": \"${account}\"}"
