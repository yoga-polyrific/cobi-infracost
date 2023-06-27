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

variable "adlStorageId" {
  type = string
}

variable "adlContainerId" {
  type = string
}

data "azurerm_resource_group" "resource_group" {
  name = "networkeco-poc"
}

resource "azurerm_synapse_workspace" "synapseWorkspace" {
  name = "${var.product-name}synapse-terra"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location = data.azurerm_resource_group.resource_group.location
  storage_data_lake_gen2_filesystem_id = "${var.adlContainerId}"
  sql_administrator_login = "ecosynapse-terra-admin"
  sql_administrator_login_password = "wGgl9LGUYxU2e74W"
  managed_virtual_network_enabled = true
  identity {
    type = "SystemAssigned"
  }
}

# resource "azurerm_synapse_managed_private_endpoint" "synapsePrivateEndpoint" {
#   name = "synapse-privateendpoint"
#   synapse_workspace_id = azurerm_synapse_workspace.synapseWorkspace.id
#   target_resource_id = "${var.adlStorageId}"
#   subresource_name = "blob"
# }