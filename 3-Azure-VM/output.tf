# output "vm_public_ip" {
#   description = "Public IP address of the Virtual Machine"
#   value       = azurerm_linux_virtual_machine.example.network_interface_ids[0].0.ip_configuration.0.public_ip_address
# }
output "resource_group_name" {
  value = data.azurerm_resource_group.existing.name
}

# output "public_ip_address" {
#   value = azurerm_linux_virtual_machine.example.public_ip_address
# }

# output "private_key" {
#   value     = tls_private_key.example[count.index].private_key_pem
#   sensitive = true
# }

output "ssh_public_keys" {
  value     = [for key in tls_private_key.example : key.public_key_openssh]
  sensitive = true
}

output "ssh_private_keys" {
  value     = [for key in tls_private_key.example : key.private_key_pem]
  sensitive = true
}