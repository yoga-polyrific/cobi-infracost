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

variable "functionSubnetId" {
  type = string
}

variable "insightKey" {
  type = string
}

variable "insightConnString" {
  type = string
}

variable "functionStorageName" {
  type = string
}

variable "functionStorageKey" {
  type = string
}

data "azurerm_resource_group" "resource_group" {
  name = "networkeco-poc"
}

resource "azurerm_service_plan" "ecoappPlan" {
  name = "ecoapp-plan"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location = data.azurerm_resource_group.resource_group.location
  os_type = "Linux"
  sku_name = "B1"
}

resource "azurerm_linux_function_app" "functionEco" {
  name = "functioneco-terra"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location = data.azurerm_resource_group.resource_group.location
  storage_account_name = "${var.functionStorageName}"
  storage_account_access_key = "${var.functionStorageKey}"
  service_plan_id = azurerm_service_plan.ecoappPlan.id
  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    application_insights_key = "${var.insightKey}"
    application_insights_connection_string = "${var.insightConnString}"
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "functionNet" {
  app_service_id = azurerm_linux_function_app.functionEco.id
  subnet_id = "${var.functionSubnetId}"
}