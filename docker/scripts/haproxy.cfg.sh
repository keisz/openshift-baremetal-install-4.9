#!/usr/bin/env bash

#APISERVERLISTにMasterとBootstrapサーバーIPを追加
if grep -q "#APISERVERLIST" ./haproxy/haproxy.cfg; then
    for var in ${MASTER_IPS[@]} ${BOOTSTRAP_IP}
    do
        var=`printf ${var}`
        APISERV=$(echo server ${var} ${var}:6443 check)
        MACHINESERV=$(echo server ${var} ${var}:22623 check)
        sed -i -e '/#APISERVERLIST/a \    '"$APISERV"'' ./haproxy/haproxy.cfg
        sed -i -e '/#MACHINESERVERLIST/a \    '"$MACHINESERV"'' ./haproxy/haproxy.cfg
    done
    sed -i -e '/#APISERVERLIST/d' ./haproxy/haproxy.cfg
    sed -i -e '/#MACHINESERVERLIST/d' ./haproxy/haproxy.cfg
fi

if grep -q "#HTTP_LIST" ./haproxy/haproxy.cfg; then
    for var in ${WORKER_IPS[@]}
    do
        var=`printf ${var}`
        sed -i -e '/#HTTP_LIST/a \    server '${var}' '${var}':80 check' ./haproxy/haproxy.cfg
        sed -i -e '/#HTTPS_LIST/a \    server '${var}' '${var}':443 check' ./haproxy/haproxy.cfg
    done
    sed -i -e '/#HTTP_LIST/d' ./haproxy/haproxy.cfg
    sed -i -e '/#HTTPS_LIST/d' ./haproxy/haproxy.cfg
fi

