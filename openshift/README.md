# OpenShift install  

OpenShift-installを利用して、設定ファイルおよび ignitionファイルの作成を行い、対象ノードにOpenShiftをインストールします。  

## 準備するもの
- oc/kubectl/openshift-install
  - github上のスクリプトを実行してインストール可能  
- OpenShift pull secret
  - https://cloud.redhat.com/openshift/install/pull-secret  
- docker/docker-compose

## OpenShift Pull Secret
https://cloud.redhat.com/openshift/install/pull-secret 

> イメージプルシークレットは、OpenShift コンポーネントのコンテナーイメージを提供するサービスおよびレジストリーにアクセスするための認証を提供します。各ユーザーには単一のプルシークレットが生成されます。この同じプルシークレットは、OpenShift Container Platform または OpenShift Dedicated クラスターのインストール時に使用されます。

OpenShiftのインストール時に必須になります。ダウンロードするにはRed Hatアカウントも必要になります。  

PullSecretのファイルをダウンロードして保存しておきます。  

## インストール前準備 手順
*install-config.yaml*をファイルを作成後に*openshift-install*を実行し、マニフェストを生成・編集後、ignition-configを生成します。
ignition-configは OpenShiftのノードをRHCOSのISOイメージからブートし、指定することでOpenShiftノードのインストールが完了します。  

### install-config.yaml 
1. `cd openshift`
2. `./generate-sshkey.sh` スクリプトを実行します。 *sshkey*dirにファイルが作成されます。 
3. `./install-config.sh` スクリプトを実行します。
4. *install-config.yaml* の **sshkey** と **pullsecret** を追加します。  
   
### openshift-install
1. `./openshift-install.sh` スクリプトを実行します。

## ノードへのインストール
RHCOSのISOイメージを利用してマシンを起動します。  
ISOイメージは[ここから](https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/4.9/)ダウンロードできます。  
ISOイメージをマウントして起動するとコンソールで操作ができますので作業を進めます。

### ネットワーク設定  
ネットワーク設定を行います。

ここでは、下記の値を設定する想定でコマンドを実行しています。自身の環境に合わせて適宜読み替えてください。  
> ノードのIPは**ENV**で指定していますのでそちらと合わせてください。

||||
|:-|:-|:-|
|IP|192.168.100.50/24|
|gateway|192.168.100.254|
|dns|192.168.100.48|docker-composeを実行したホストIP|

```
nmcli con del "Wired connection 1"
nmcli con add con-name ens3 type ethernet ipv4.method manual ipv4.addresses 192.168.100.50/24 ipv4.gateway 192.168.100.254 ipv4.dns 192.168.100.48
nmcli con up ens3
nmcli con show
```

### OpenShiftインストール
ノードに対してインストールを実行します。
ノードの役割ごとに *--ignition-url* で指定する ignitionファイルが異なります。
WebサーバーのIPは *docker-compose* を実行したLinuxホストです。  

- bootstrap node
```
sudo coreos-installer install --ignition-url=http://192.168.100.48:8008/bootstrap.ign /dev/sda -n --insecure-ignition
```

- master node
```
sudo coreos-installer install --ignition-url=http://192.168.100.48:8008/master.ign /dev/sda -n --insecure-ignition
```

- worker node
```
sudo coreos-installer install --ignition-url=http://192.168.100.48:8008/worker.ign /dev/sda -n --insecure-ignition
```

各ノードでコマンド実行が完了したら再起動します。
この時、BootStrap -> Master -> Worker の順番で実行してください。  


## インストールの確認  

- Bootstrap Complete

```
cd openshift/
openshift-install --dir=bare-metal/ wait-for bootstrap-complete
```
```
[root@alma85 openshift]# openshift-install --dir=bare-metal/ wait-for bootstrap-complete
INFO Waiting up to 20m0s for the Kubernetes API at https://api.tdoc.ks-pic.local:6443...
INFO API v1.22.1+d8c4430 up
INFO Waiting up to 30m0s for bootstrapping to complete...
INFO It is now safe to remove the bootstrap resources
INFO Time elapsed: 0s
```

- csr approve
Worker nodeが追加されたときにCSRの承認がPendingになることがあるので確認します。  

`oc get csr --kubeconfig=bare-metal/auth/kubeconfig`

PendingになってるCSRがある場合

`oc get csr -o name --kubeconfig=bare-metal/auth/kubeconfig | xargs oc adm certificate approve --kubeconfig=bare-metal/auth/kubeconfig`

```
[root@alma85 openshift]# oc get csr -o name --kubeconfig=bare-metal/auth/kubeconfig | xargs oc adm certificate approve --kubeconfig=bare-metal/auth/kubeconfig
certificatesigningrequest.certificates.k8s.io/csr-cnl66 approved
certificatesigningrequest.certificates.k8s.io/csr-fdnc5 approved
certificatesigningrequest.certificates.k8s.io/csr-hwg6m approved
certificatesigningrequest.certificates.k8s.io/csr-j5645 approved
certificatesigningrequest.certificates.k8s.io/csr-p6k52 approved
certificatesigningrequest.certificates.k8s.io/csr-sjvm6 approved
```

- Install Complete
```
openshift-install --dir=bare-metal wait-for install-complete
```
```
[root@alma85 openshift]# openshift-install --dir=bare-metal wait-for install-complete
INFO Waiting up to 40m0s for the cluster at https://api.tdoc.ks-pic.local:6443 to initialize...
INFO Waiting up to 10m0s for the openshift-console route to be created...
INFO Install complete!
INFO To access the cluster as the system:admin user when using 'oc', run 'export KUBECONFIG=/root/openshift/bare-metal/auth/kubeconfig'
INFO Access the OpenShift web-console here: https://console-openshift-console.apps.tdoc.ks-pic.local
INFO Login to the console with user: "kubeadmin", and password: "8V8tC-j6fKi-mMNvJ-oUa7S"
INFO Time elapsed: 0s
```
WebコンソールのIDをパスワードが表示されます。  

- Cluster Operators status
`oc get clusteroperators --kubeconfig=bare-metal/auth/kubeconfig`
```
[root@alma85 openshift]# oc get clusteroperators --kubeconfig=bare-metal/auth/kubeconfig
NAME                                       VERSION   AVAILABLE   PROGRESSING   DEGRADED   SINCE   MESSAGE
authentication                             4.9.6     True        False         False      4h39m
baremetal                                  4.9.6     True        False         False      5h16m
cloud-controller-manager                   4.9.6     True        False         False      5h18m
cloud-credential                           4.9.6     True        False         False      5h17m
cluster-autoscaler                         4.9.6     True        False         False      5h16m
config-operator                            4.9.6     True        False         False      5h17m
console                                    4.9.6     True        False         False      4h43m
csi-snapshot-controller                    4.9.6     True        False         False      5h17m
dns                                        4.9.6     True        False         False      5h16m
etcd                                       4.9.6     True        False         False      5h15m
image-registry                             4.9.6     True        False         False      5h10m
ingress                                    4.9.6     True        False         False      4h45m
insights                                   4.9.6     True        False         False      5h10m
kube-apiserver                             4.9.6     True        False         False      5h13m
kube-controller-manager                    4.9.6     True        False         False      5h15m
kube-scheduler                             4.9.6     True        False         False      5h15m
kube-storage-version-migrator              4.9.6     True        False         False      5h17m
machine-api                                4.9.6     True        False         False      5h16m
machine-approver                           4.9.6     True        False         False      5h16m
machine-config                             4.9.6     True        False         False      5h15m
marketplace                                4.9.6     True        False         False      5h16m
monitoring                                 4.9.6     True        False         False      4h45m
network                                    4.9.6     True        False         False      5h17m
node-tuning                                4.9.6     True        False         False      82m
openshift-apiserver                        4.9.6     True        False         False      5h10m
openshift-controller-manager               4.9.6     True        False         False      5h16m
openshift-samples                          4.9.6     True        False         False      5h10m
operator-lifecycle-manager                 4.9.6     True        False         False      5h16m
operator-lifecycle-manager-catalog         4.9.6     True        False         False      5h17m
operator-lifecycle-manager-packageserver   4.9.6     True        False         False      5h10m
service-ca                                 4.9.6     True        False         False      5h17m
storage                                    4.9.6     True        False         False      5h17m
```

### その他  
今回はCoreDNSでOpenShift Nodeの逆引きができるようにしているため問題は発生しないが、逆引きができないDNS設定の場合にNodeがホスト名を設定しない(localhost.localdomain)ためにインストールに失敗する。この場合には下記のURLを参考に master.ignおよびworker.ignを編集することでインストール可能になります。
https://bugzilla.redhat.com/show_bug.cgi?id=1905986
