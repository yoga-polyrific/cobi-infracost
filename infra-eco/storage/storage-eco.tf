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

variable "defaultSubnetId" {
  type = string
}

data "azurerm_resource_group" "resource_group" {
  name = "networkeco-poc"
}



resource "azurerm_storage_account" "storageAccont" {
  name = "${var.product-name}datalake2"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location = data.azurerm_resource_group.resource_group.location
  account_tier = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled = true
  access_tier = "Hot"
}

resource "azurerm_storage_account_network_rules" "adlNet" {
  storage_account_id = azurerm_storage_account.storageAccont.id
  default_action = "Allow"
  ip_rules = [ "110.139.62.19" ]
  virtual_network_subnet_ids = ["${var.defaultSubnetId}"]
}

resource "azurerm_storage_data_lake_gen2_filesystem" "ADLv2" {
  name = "cobiadlv2"
  storage_account_id = azurerm_storage_account.storageAccont.id
}

resource "azurerm_storage_account" "functionStorage" {
  name = "${var.product-name}function"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location = data.azurerm_resource_group.resource_group.location
  account_tier = "Standard"
  account_replication_type = "LRS"
  access_tier = "Hot"
}

resource "azurerm_storage_account_network_rules" "functionNet" {
  storage_account_id = azurerm_storage_account.functionStorage.id
  default_action = "Allow"
  ip_rules = [ "110.139.62.19" ]
  virtual_network_subnet_ids = ["${var.defaultSubnetId}"]
}