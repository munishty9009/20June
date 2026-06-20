output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.rg.name
}

output "vm_name" {
  description = "Name of the Linux Virtual Machine"
  value       = azurerm_linux_virtual_machine.vm.name
}

output "public_ip_address" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.pip.ip_address
}

output "private_ip_address" {
  description = "Private IP address of the VM"
  value       = azurerm_network_interface.nic.private_ip_address
}

output "ssh_command" {
  description = "SSH command to connect to the VM"
  value       = "ssh -i ~/.ssh/id_rsa ${var.admin_username}@${azurerm_public_ip.pip.ip_address}"
}

output "vm_id" {
  description = "Azure Resource ID of the VM"
  value       = azurerm_linux_virtual_machine.vm.id
}
