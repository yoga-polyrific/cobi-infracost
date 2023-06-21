output "dbserver" {
  value = azurerm_mssql_server.sqlServer.name
}

output "dbname" {
  value = azurerm_mssql_database.sqlDatabase.name
}

output "dbUser" {
  value = azurerm_mssql_server.sqlServer.administrator_login
}

output "dbPass" {
  value = azurerm_mssql_server.sqlServer.administrator_login_password
}