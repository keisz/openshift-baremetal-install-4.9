#!/usr/bin/env bash

## envファイルを読み込み  
source ../env

## ドメイン名とクラスター名を変更
if grep -q "###DOMAIN_NAME" ./install-config.yaml; then
    sed -i -e"s/###DOMAIN_NAME/$BASE_DOMAIN/g" ./install-config.yaml
    sed -i -e"s/###CLUSTER_NAME/$CLUSTER_NAME/g" ./install-config.yaml
fi

echo "SSHKEYとPullSecretは手動で追記してください"