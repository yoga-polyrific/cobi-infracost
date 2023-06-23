output "defaultSubnetId" {
  value = azurerm_subnet.subnetDefault.id
}

output "functionSubnetId" {
  value = azurerm_subnet.subnetWeb.id
}