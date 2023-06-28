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

module "insight" {
  source = "./insight"
}

module "function" {
  source = "./function"
  functionSubnetId = module.network.functionSubnetId
  insightKey = module.insight.insightKey
  insightConnString = module.insight.insightConnString
  functionStorageName = module.storage.functionStorageName
  functionStorageKey = module.storage.functionStorageKey
}

module "synapse" {
  source = "./synapse"
  adlContainerId = module.storage.adlContainerId
  adlStorageId = module.storage.adlStorageId
  defaultSubnetId = module.network.defaultSubnetId
}


# module "endpoints" {
#   source = "./privateEndpoints"
#   defaultSubnetId = module.network.defaultSubnetId
#   dbId = module.databases.dbId
#   adfId = module.datafactory.adfId
#   funcId = module.function.funcId
#   vaultId = module.keyvault.vaultId
#   synId = module.synapse.synId
# }

module "nsg" {
  source = "./NSG"
  defaultSubnetId = module.network.defaultSubnetId
}

module "netwatch" {
  source = "./network-watcher"
  nsgId = module.nsg.nsgId
}