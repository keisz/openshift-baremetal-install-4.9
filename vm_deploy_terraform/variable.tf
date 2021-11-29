#Variable
##Define Variables for Platform
variable "vsphere_user" {}              #vsphereのユーザー名
variable "vsphere_password" {}          #vsphereのパスワード
variable "vsphere_vc_server" {}         #vCenterのFQDN/IPアドレス
variable "vsphere_datacenter" {}        #vsphereのデータセンター
variable "vsphere_datastore" {}         #vsphereのデータストア
variable "vsphere_cluster" {}           #vsphereのクラスター
variable "vsphere_network_1" {}         #vsphereのネットワーク
variable "vsphere_resource_pool" {}     #ResourcePool名
variable "vsphere_template_name" {}     #プロビジョニングするテンプレート

##Define Variables for Virtual Machines
variable "prov_vm_num" {}               #プロビジョニングする仮想マシンの数
variable "prov_vmname_prefix" {}        #プロビジョニングする仮想マシンの接頭語
variable "prov_cpu_num" {}              #プロビジョニングする仮想マシンのCPUの数
variable "prov_mem_num" {}              #プロビジョニングする仮想マシンのメモリのMB

variable "vsphere_iso" {}               #vsphereのisoデータストア