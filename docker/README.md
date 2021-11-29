# DNS/LB/Web の実行  

OpenShiftをベアメタルインストールする際に必要となるDNSサーバー、LoadBalancer、WebサーバーをDockerで構成します。  
各パラメータを指定した後に `docker-compose up -d` で実行します。  

## docker 
|||
|:-|:-|
|DNS|CoreDNS|
|LoadBalancer|HAProxy|
|Web|Nginx|

## 手順  
1. *ENV* にパラメータが指定されていることを確認します。
2. `cd docker/`   
3. `./config_create.sh` でスクリプトを実行します。  
4. `docker-compose up -d`
5. `docker ps` で3つのコンテナが動いていることを確認します。  

