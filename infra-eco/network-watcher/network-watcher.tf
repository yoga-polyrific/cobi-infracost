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

variable "nsgId" {
  type = string
}

data "azurerm_resource_group" "resource_group" {
  name = "networkeco-poc"
}

data "azurerm_storage_account" "existStorage" {
  name = "cobiterra"
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

resource "azurerm_network_watcher" "netwatchEco" {
  name = "${var.product-name}netwatch-terra"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location = data.azurerm_resource_group.resource_group.location
}

resource "azurerm_network_watcher_flow_log" "netwatchLog" {
  name = "${var.product-name}netwatch-logs"
  network_watcher_name = azurerm_network_watcher.netwatchEco.name
  resource_group_name = data.azurerm_resource_group.resource_group.name

  network_security_group_id = "${var.nsgId}"
  storage_account_id = data.azurerm_storage_account.existStorage.id
  enabled = true

  retention_policy {
    enabled = true
    days = 7
  }
}