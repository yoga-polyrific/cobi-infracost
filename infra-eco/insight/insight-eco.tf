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

data "azurerm_resource_group" "resource_group" {
  name = "networkeco-poc"
}

resource "azurerm_application_insights" "insightFunction" {
  name = "${var.product-name}Insight-function"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location = data.azurerm_resource_group.resource_group.location
  application_type = "web"
}