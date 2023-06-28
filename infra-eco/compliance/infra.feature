Feature: Azure Resource Creation

  Scenario: Verify the creation of Azure Data Factory
    Given I have an Azure Data Factory named "ecopetroldatafactory" in the resource group "networkeco-poc"
    Then the Azure Data Factory should exist

  Scenario: Verify the creation of Azure SQL Database and Server
    Given I have an Azure SQL Database named "ecopetrol-db-terra" and an Azure SQL Server named "my-sql-server" in the resource group "networkeco-poc"
    Then the Azure SQL Database and Server should exist

  Scenario: Verify the creation of Azure Function App
    Given I have an Azure Function App named "functioneco-terra" in the resource group "networkeco-poc"
    Then the Azure Function App should exist

  Scenario: Verify the creation of Application Insights
    Given I have an Application Insights instance named "ecopetrolInsight-function" in the resource group "networkeco-poc"
    Then the Application Insights instance should exist

  Scenario: Verify the creation of Azure Key Vault
    Given I have an Azure Key Vault named "ecopetrolkeyvaultterra" in the resource group "networkeco-poc"
    Then the Azure Key Vault should exist

  Scenario: Verify the creation of Network Watcher
    Given I have a Network Watcher named "ecopetrol-netwatch-terra" in the resource group "networkeco-poc"
    Then the Network Watcher should exist

  Scenario: Verify the creation of Network Security Group
    Given I have a Network Security Group named "ecopetrolNsg-terra" in the resource group "networkeco-poc"
    Then the Network Security Group should exist

  Scenario: Verify the creation of Storage Account
    Given I have a Storage Account named "ecopetroldatalake2" in the resource group "networkeco-poc"
    Then the Storage Account should exist

  Scenario: Verify the creation of Azure Synapse
    Given I have an Azure Synapse instance named "ecopetrolsynapse-terra" in the resource group "networkeco-poc"
    Then the Azure Synapse instance should exist

  Scenario: Verify the creation of Azure Virtual Network
    Given I have an Azure Virtual Network named "ecopetrol-network-terraform" in the resource group "networkeco-poc"
    Then the Azure Virtual Network should exist
