terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
        }
    }
    # backend "azurerm" {
    #   resource_group_name = "networkeco-poc"
    #   storage_account_name = "cobiterra"
    #   container_name = "network"
    #   key = "terraform.tfstate"
    #   features{}
    # }
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

data "azurerm_resource_group" "resource_group" {
  name = "networkeco-poc"
}

resource "azurerm_virtual_network" "vnet" {
  name = "${var.product-name}-network-terraform"
  location = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  address_space = [ "10.0.0.0/16" ]
}

resource "azurerm_subnet" "subnetFirewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = data.azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnetManagedFirewall" {
  name                 = "AzureFirewallManagementSubnet"
  resource_group_name  = data.azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "subnetDefault" {
  name                 = "default"
  resource_group_name  = data.azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
  service_endpoints = [ "Microsoft.Storage", "Microsoft.Sql", "Microsoft.Web" ]
}

resource "azurerm_subnet" "subnetWeb" {
  name                 = "FunctionSubnet"
  resource_group_name  = data.azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.4.0/24"]
  service_endpoints = [ "Microsoft.Web" ]
  delegation {
    name = "functiondelegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}

resource "azurerm_public_ip" "ip-public" {
  name = "${var.product-name}-ip-terraform"
  location = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  allocation_method = "Static"
  sku = "Standard"
}

resource "azurerm_firewall" "firewall" {
  name = "${var.product-name}-firewall-terraform"
  location = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  sku_name = "AZFW_VNet"
  sku_tier = "Standard"

  ip_configuration {
    name = "IpConfig"
    subnet_id = azurerm_subnet.subnetFirewall.id
    public_ip_address_id = azurerm_public_ip.ip-public.id
  }
}

