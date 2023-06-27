terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
        }
    }
}


provider "azurerm" {
  skip_provider_registration = true
  features {
    
  }
}

variable "product-name" {
  type = string
  default = "ecopetrol"
}

variable "defaultSubnetId" {
  type = string
}

data "azurerm_resource_group" "resource_group" {
  name = "networkeco-poc"
}

resource "azurerm_network_security_group" "nsgEco" {
  name = "${var.product-name}Nsg-terra"
  location = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

resource "azurerm_network_security_rule" "nsgRule1" {
  name = "nsgRule1"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  network_security_group_name = azurerm_network_security_group.nsgEco.name
  priority = 100
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = 80
  source_address_prefix = "VirtualNetwork"
  destination_address_prefix = "VirtualNetwork"
}

resource "azurerm_subnet_network_security_group_association" "nsgAssociation" {
  network_security_group_id = azurerm_network_security_group.nsgEco.id
  subnet_id = "${var.defaultSubnetId}"
}