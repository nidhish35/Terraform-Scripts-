variable "resource_group_name" {
  description = "Name of the existing Azure Resource Group"
  type        = string
  default     = "DevOps-Testing-Environment"
}

variable "virtual_network_name" {
  description = "Name of the Azure Virtual Network"
  type        = string
  default     = "Test-vnet"
}

variable "address_space" {
  description = "Address space for the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "Name of the Azure Subnet"
  type        = string
  default     = "internal"
}

variable "subnet_address_prefixes" {
  description = "Address prefixes for the Subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "network_interface_name" {
  description = "Name of the Azure Network Interface"
  type        = list(string)
  default     = ["database-nic", "apisix-nic", "entry-network-nic"]
}

variable "azurerm_public_ip" {
  description = "Name of the IP"
  type        = list(string)
  default     = ["database-IP", "apisix-IP", "entry-network-IP"]
}

variable "network_interface_configuration_name" {
  description = "Name of the IP configuration for the Network Interface"
  type        = list(string)
  default     = ["database-nic", "apisix-nic", "entry-network-nic"]
}

variable "virtual_machine_name" {
  description = "Name of the Azure Virtual Machine"
  type        = list(string)
  default     = ["database-vm", "apisix-vm", "entry-network-vm"]
}

variable "virtual_machine_size" {
  description = "Size of the Azure Virtual Machine"
  type        = string
  default     = "Standard_F2"
}

variable "azurerm_network_security_group" {
  description = "Name of the Network Security Groups"
  type        = list(string)
  default     = ["database-nsg", "apisix-nsg", "entry-network-nsg"]
}

variable "admin_username" {
  description = "Admin username for the Virtual Machine"
  type        = list(string)
  default     = ["nidhish", "asit", "advait"]
}

variable "admin_password" {
  description = "Admin password"
  default     = "Admin@1"
}

variable "image_publisher" {
  description = "Publisher of the OS image"
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "Offer of the OS image"
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  description = "SKU of the OS image"
  type        = string
  default     = "22_04-lts"
}

variable "image_version" {
  description = "Version of the OS image"
  type        = string
  default     = "latest"
}

variable "storage_account_name" {
  description = "Name of the storage account for the extension"
  type        = string
  default     = "testing"
}

variable "storage_account_key" {
  description = "Key of the storage account for the extension"
  type        = string
  default     = "test"
}

#Edited

variable "vm_count" {
  description = "Number of virtual machines to create"
  type        = number
  default     = 3
}

variable "ssh_source_address_prefix" {
  description = "Source IP address or range for SSH traffic"
  type        = string
  # You can set a default value if needed
}
