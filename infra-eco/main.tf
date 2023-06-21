terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
        }
    }
     backend "azurerm" {
       resource_group_name = "networkeco-poc"
       storage_account_name = "cobiterra"
       container_name = "network"
       key = "terraform.tfstate"
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

module "network" {
  source = "./vnet"
}

module "storage" {
  source = "./storage"
  defaultSubnetId = module.network.defaultSubnetId
}

module "databases" {
  source = "./database"
  defaultSubnetId = module.network.defaultSubnetId
}

module "datafactory" {
  source = "./data-factory"
  dbserver = module.databases.dbserver
  dbname = module.databases.dbname
  dbUser = module.databases.dbUser
  dbPass = module.databases.dbPass
}