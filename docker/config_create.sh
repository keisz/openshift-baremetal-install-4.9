#!/usr/bin/env bash
SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR

## envファイルを読み込み  
source ../env

## haproxy.cfgを変更
source ./scripts/haproxy.cfg.sh

## CoreDNSのCorefileを変更
source ./scripts/coredns.corefile.sh

## CoreDNSのdns.dbを変更
source ./scripts/coredns.dns.db.sh

## CoreDNSのhostsを変更
source ./scripts/coredns.hosts.sh

