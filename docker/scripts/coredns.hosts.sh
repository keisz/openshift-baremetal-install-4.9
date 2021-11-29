#!/usr/bin/env bash

if grep -q "#HOSTS" ./coredns/hosts; then
    #Master
    for i in ${!MASTER_IPS[@]} 
    do
    sed -i -e '/#HOSTS/a \'${MASTER_IPS[$i]}' master'$i'.'$CLUSTER_NAME'.'$BASE_DOMAIN'' ./coredns/hosts
    done
    
    #Worker
    for i in ${!WORKER_IPS[@]} 
    do
    sed -i -e '/#HOSTS/a \'${WORKER_IPS[$i]}' worker'$i'.'$CLUSTER_NAME'.'$BASE_DOMAIN'' ./coredns/hosts
    done   
    
    #BootStrap
    sed -i -e '/#HOSTS/a \'$BOOTSTRAP_IP' bootstrap.'$CLUSTER_NAME'.'$BASE_DOMAIN'' ./coredns/hosts
    
    #LB/api/api-int
    sed -i -e '/#HOSTS/a \'$DOCKER_HOST_IP' lb.'$CLUSTER_NAME'.'$BASE_DOMAIN'' ./coredns/hosts  
    sed -i -e '/#HOSTS/a \'$DOCKER_HOST_IP' api.'$CLUSTER_NAME'.'$BASE_DOMAIN'' ./coredns/hosts 
    sed -i -e '/#HOSTS/a \'$DOCKER_HOST_IP' api-int.'$CLUSTER_NAME'.'$BASE_DOMAIN'' ./coredns/hosts 

    #remove
    sed -i -e '/#HOSTS/d' ./coredns/hosts
fi
