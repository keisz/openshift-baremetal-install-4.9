#Provider
provider "vsphere" {
  user                   = var.vsphere_user
  password               = var.vsphere_password
  vsphere_server         = var.vsphere_vc_server
  allow_unverified_ssl   = true
}

#Data
data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "iso" {
  name          = var.vsphere_iso
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

#Resource
resource "vsphere_virtual_machine" "vm" {
  count            = var.prov_vm_num
   name            = "${var.prov_vmname_prefix}${format("%02d",count.index)}"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

#Resource for VM Specs
  num_cpus = var.prov_cpu_num
  memory   = var.prov_mem_num
  guest_id = var.prov_guest_id
  #scsi_type = "pvscsi"

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = "vmxnet3"
  }

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0


#Resource for Disks
  disk {
    label            = "disk0"
    size             = 120
  }

  disk {
    label            = "disk1"
    size             = 100
    unit_number      = 1
  }

  cdrom {
    datastore_id = "${data.vsphere_datastore.iso.id}"
    path         = "iso/rhcos-4.9.0-x86_64-live.x86_64.iso"
  }

}
