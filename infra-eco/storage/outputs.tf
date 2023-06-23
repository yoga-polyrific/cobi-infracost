output "functionStorageName" {
  value = azurerm_storage_account.functionStorage.name
}

output "functionStorageKey" {
  value = azurerm_storage_account.functionStorage.primary_access_key
}