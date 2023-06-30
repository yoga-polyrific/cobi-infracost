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

resource "azurerm_mssql_server" "sqlServer" {
  name = "${var.product-name}-server"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location = data.azurerm_resource_group.resource_group.location
  administrator_login = "cobieco-terra"
  administrator_login_password = "A#0W4Bb0MWl1cC9L"
  version = "12.0"
  public_network_access_enabled = false
}

resource "azurerm_mssql_virtual_network_rule" "dbNet" {
  name = "${var.product-name}-sql-vnet"
  server_id = azurerm_mssql_server.sqlServer.id
  subnet_id = "${var.defaultSubnetId}"
}

resource "azurerm_mssql_database" "sqlDatabase" {
  name = "${var.product-name}-db-terra"
  server_id = azurerm_mssql_server.sqlServer.id
  collation = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb = 2
  sku_name = "Basic"
}

