output "VM_hostname" {
  description = "VM Names"
  value       = vsphere_virtual_machine.vm.*.name
}
