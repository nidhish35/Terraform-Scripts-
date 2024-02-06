terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}
provider "azurerm" {
  skip_provider_registration = true
  features {}
}

# Reference to the existing resource group
data "azurerm_resource_group" "existing" {
  name = var.resource_group_name
}

locals {
  today = formatdate("DD-MM-YY", timestamp())
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.virtual_network_name}-${local.today}"
  address_space       = var.address_space
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name
}

resource "azurerm_subnet" "example" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.existing.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = var.subnet_address_prefixes
}

resource "azurerm_public_ip" "example" {
  count               = var.vm_count
  name                = "${var.azurerm_public_ip[count.index]}-${local.today}"
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_security_group" "example" {
  count               = var.vm_count
  name                = "${var.azurerm_network_security_group[count.index]}-${local.today}"
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.ssh_source_address_prefix
    destination_address_prefix = "*"
  }
}


resource "azurerm_network_interface" "example" {
  count               = var.vm_count
  name                = "${var.network_interface_name[count.index]}-${local.today}"
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name

  ip_configuration {
    name                          = var.network_interface_configuration_name[count.index]
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example[count.index].id
  }
}


# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  count                     = var.vm_count
  network_interface_id      = azurerm_network_interface.example[count.index].id
  network_security_group_id = azurerm_network_security_group.example[count.index].id
}

resource "tls_private_key" "example" {
  count     = var.vm_count
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "random_password" "password" {
  length           = 12
  special          = true
  override_special = "_%@"
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
}

resource "azurerm_linux_virtual_machine" "example" {
  count                           = length(var.virtual_machine_name)
  name                            = "${var.virtual_machine_name[count.index]}-${local.today}"
  location                        = data.azurerm_resource_group.existing.location
  resource_group_name             = data.azurerm_resource_group.existing.name
  network_interface_ids           = [azurerm_network_interface.example[count.index].id]
  zone                            = "1"
  size                            = var.virtual_machine_size
  admin_username                  = var.admin_username[count.index]
  admin_password                  = random_password.password.result
  disable_password_authentication = false

  admin_ssh_key {
    username   = var.admin_username[count.index]
    public_key = tls_private_key.example[count.index].public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
}
