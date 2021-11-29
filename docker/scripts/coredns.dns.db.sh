#!/usr/bin/env bash

if grep -q "#CLUSTER_NAME_DOMAIN_NAME" ./coredns/dns.db; then
    sed -i -e"s/#CLUSTER_NAME_DOMAIN_NAME/$CLUSTER_NAME.$BASE_DOMAIN/g" ./coredns/dns.db
    sed -i -e"s/#DOCKER_HOST_IP/$DOCKER_HOST_IP/g" ./coredns/dns.db
fi