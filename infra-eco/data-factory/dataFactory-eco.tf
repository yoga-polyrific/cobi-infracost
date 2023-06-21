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

variable "dbserver" {
  type = string
}

variable "dbname" {
  type = string
}

variable "dbUser" {
  type = string
}

variable "dbPass" {
  type = string
}

data "azurerm_resource_group" "resource_group" {
  name = "networkeco-poc"
}

resource "azurerm_data_factory" "dataFactory" {
  name = "${var.product-name}datafactory"
  location = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

resource "azurerm_data_factory_linked_service_sql_server" "serviceSql" {
  name = "linkservice-sql-terra"
  data_factory_id = azurerm_data_factory.dataFactory.id
  connection_string = "Server=tcp:${var.dbserver}.database.windows.net,1433;Initial Catalog=${var.dbname};Persist Security Info=False;User ID=${var.dbUser};Password=${var.dbPass};MultipleActiveResultSets=True;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}