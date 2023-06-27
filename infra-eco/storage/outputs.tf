output "functionStorageName" {
  value = azurerm_storage_account.functionStorage.name
}

output "functionStorageKey" {
  value = azurerm_storage_account.functionStorage.primary_access_key
}

output "adlStorageId" {
  value = azurerm_storage_account.storageAccont.id
}

output "adlContainerId" {
  value = azurerm_storage_data_lake_gen2_filesystem.ADLv2.id
}