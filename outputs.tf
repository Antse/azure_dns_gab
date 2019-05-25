output "vm_name" {
  value = ["${azurerm_virtual_machine.vm.*.name}"]
}

output "vm-vnet2" {
  value = "${azurerm_virtual_machine.vm2.name}"
}

output "vm-vnet3" {
  value = "${azurerm_virtual_machine.vm3.name}"
}

output "win_vm_ip" {
  value = "${azurerm_public_ip.test3.fqdn}"
}

output "private_ips" {
  value = ["${azurerm_network_interface.nic.*.private_ip_address}"]
}
