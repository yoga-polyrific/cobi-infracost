Feature: Terraform Compliance Test

  Background:
    Given the required Terraform providers are defined

  Scenario Outline: Ensure Terraform configuration is compliant
    Given the Azure provider is configured with skip_provider_registration set to true
    And the product name variable is set to "ecopetrol"
    And the functionSubnetId variable is defined
    And the insightKey variable is defined
    And the insightConnString variable is defined
    And the functionStorageName variable is defined
    And the functionStorageKey variable is defined
    And the azurerm_resource_group data source is defined with name "otherresources-eco-poc"
    And the azurerm_service_plan resource is defined with name "ecoapp-plan" and sku_name "B1"
    And the azurerm_linux_function_app resource is defined with name "functioneco-terra" and application_stack dotnet_version "6.0"
    And the azurerm_app_service_virtual_network_swift_connection resource is defined with app_service_id and subnet_id

    When Terraform applies the configuration

    Then the azurerm_service_plan resource with name "ecoapp-plan" should exist
    And the azurerm_linux_function_app resource with name "functioneco-terra" should exist
    And the azurerm_app_service_virtual_network_swift_connection resource should exist

    And the azurerm_linux_function_app resource should have the correct configuration:
      | storage_account_name                  | ${var.functionStorageName}        |
      | storage_account_access_key            | ${var.functionStorageKey}         |
      | service_plan_id                       | azurerm_service_plan.ecoappPlan.id |
      | site_config.application_stack.dotnet_version | 6.0                        |
      | site_config.application_insights_key  | ${var.insightKey}                 |
      | site_config.application_insights_connection_string | ${var.insightConnString} |

    And the azurerm_app_service_virtual_network_swift_connection resource should have the correct configuration:
      | app_service_id                     | azurerm_linux_function_app.functionEco.id |
      | subnet_id                          | ${var.functionSubnetId}