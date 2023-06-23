output "insightKey" {
  value = azurerm_application_insights.insightFunction.instrumentation_key
}

output "insightConnString" {
  value = azurerm_application_insights.insightFunction.connection_string
}