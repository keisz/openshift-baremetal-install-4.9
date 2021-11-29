#!/usr/bin/env bash

if grep -q "#CLUSTER_NAME_DOMAIN_NAME" ./coredns/corefile; then
    sed -i -e"s/#CLUSTER_NAME_DOMAIN_NAME/$CLUSTER_NAME.$BASE_DOMAIN/g" ./coredns/corefile
    sed -i -e"s/#EXTERNAL_DNS/$EXTERNAL_DNS/g" ./coredns/corefile
fi



