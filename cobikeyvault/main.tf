terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
        }
        azuread = {
            source = "hashicorp/azuread"
        }
    }
}

provider "azurerm" {
  skip_provider_registration = true
  features {
    
  }
}

provider "azuread" {
  tenant_id = "3b1cf49a-5c5c-4f46-b1fc-c6c2486a52aa"
}

variable "product-name" {
  type = string
  default = "cobi"
}

variable "secretValue1" {
  type = string
  default = "secret1"
}

data "azurerm_resource_group" "resource_group" {
  name = "ssos-securenetpoc"
}

data "azuread_client_config" "clientYoga" {
}

resource "azurerm_key_vault" "keyVaultEco" {
  name = "${var.product-name}keyvaultterra"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location = data.azurerm_resource_group.resource_group.location
  tenant_id = data.azuread_client_config.clientYoga.tenant_id
  sku_name = "standard"
}

resource "azurerm_key_vault_access_policy" "kvAccessPolicyYoga" {
  key_vault_id = azurerm_key_vault.keyVaultEco.id
  tenant_id = data.azuread_client_config.clientYoga.id
  object_id = data.azuread_client_config.clientYoga.object_id
  secret_permissions = [ "Get", "Set", "Delete" ]
}

resource "azurerm_key_vault_secret" "kvsecret" {
  name = "cobisecret"
  value = "${var.secretValue}"
  key_vault_id = azurerm_key_vault.keyVaultEco.id
}