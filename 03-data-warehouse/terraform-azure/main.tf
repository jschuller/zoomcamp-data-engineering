terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.x.x" 
    }
  }
}

provider "azurerm" {
  features {}
}

# Azure Storage Account resource
resource "azurerm_storage_account" "data_lake_storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Azure Storage Container resource
resource "azurerm_storage_container" "container" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.data_lake_storage_account.name
  container_access_type = "private"
}

# Azure Storage Blob resource
resource "azurerm_storage_blob" "blob" {
  name                   = var.blob_name
  storage_account_name   = azurerm_storage_account.data_lake_storage_account.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
}

# Azure Data Lake Store File resource
resource "azurerm_data_lake_store_file" "file" {
  name                 = var.file_name
  storage_account_name = azurerm_storage_account.data_lake_storage_account.name
  file_system_name     = var.file_system_name
  path                 = var.file_path
  content              = var.file_content
}

// # Azure Synapse SQL Pool resource
// resource "azurerm_synapse_sql_pool" "sql_pool" {
//   name                = var.sql_pool_name
//   resource_group_name = var.resource_group_name
//   workspace_name      = var.workspace_name
//   sku_name            = "DW100c"
//   capacity            = 100
// }
