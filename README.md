# OpenShift インストール 
date: 2021/11/25  

IBM Powerの検証用にOpenShiftを構成する手順を整理  
- RHCOS 6台でベアメタルOpenShiftを構成
  - IPアドレスはスタティック
- OpenShift version: 4.9.6

## 利用するファイル
github上のファイルをダウンロードします。  



## 作業PC  
- AlmaLinux 8.5  
  - docker/docker-compose/git

## OpenShiftを構成するために必要な環境  
すべて作業PC上にDockerで稼働させる  
- DNS: CoreDNS
- LB: HAProxy
- Web: Nginx  

### 各リソースのConf  
#### DNS/LB
**env** ファイルに必要な情報を記入してスクリプトを実行することで各Dockerコンテナの稼働に必要なファイルを作成  

#### Nginx
**openshift-install** コマンドを実行した後に生成される **.ign**ファイルを配置する必要がある

## OpenShift環境  
ベアメタルのRHCOS想定で構成。
実際作成した環境はvSphere上のVMではあるが、ベアメタル用のインストール方法で構築を行った  


## 手順  

1. 作業用PCにDocker/Docker-compose/git/wgetがインストールされていることを確認
2. githubからダウンロード
   - `git clone https://github.com/cptmorgan-rh/install-oc-tools.git`
3. **oc/kubectl/openshift-install** を実行して、oc/kubectl/openshift-installをインストール   
   ```
   cd install-oc-tools
   ./install-oc-tools.sh --version 4.9.6
   ```
4. [OpenShiftを構成するために必要な環境を稼働させる](docker/README.md)
5. [OpenShiftをインストールする](openshift/README.md)


#### package  
https://mirror.openshift.com/  
https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/4.9/  
https://console.redhat.com/openshift/install/metal/user-provisioned  

