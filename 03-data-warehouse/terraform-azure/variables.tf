variable "storage_account_name" {
  description = "Storage Account Name for Azure"
  # Update to your desired storage account name
  default     = "dtc-2024-storage-account"
}

variable "resource_group_name" {
  description = "Resource Group Name for Azure"
  # Update to your desired resource group name
  default     = "dtc2024-rg"
}

variable "location" {
  description = "Azure Location"
  # Update to your desired location
  default     = "East US"
}

variable "storage_container_name" {
  description = "Storage Container Name for Azure"
  # Update to your desired storage container name
  default     = "week-3-hw-storage-account-jschuller"
}

// variable "blob_name" {
//   description = "Blob Name for Azure"
//   # Update to your desired blob name
//   default     = "blobname"
// }

// variable "file_name" {
//   description = "Data Lake Store File Name for Azure"
//   # Update to your desired file name
//   default     = "filename"
// }
// 
// variable "file_system_name" {
//   description = "Data Lake Store File System Name for // Azure"
//   # Update to your desired file system name
//   default     = "filesystemname"
// }
// 
// variable "file_path" {
//   description = "Data Lake Store File Path for Azure"
//   # Update to your desired file path
//   default     = "/path/to/file"
// }
// 
// variable "file_content" {
//   description = "Data Lake Store File Content for Azure"
//   # Update to your desired file content
//   default     = "filecontent"
// }
// 
// variable "sql_pool_name" {
//   description = "Synapse SQL Pool Name for Azure"
//   # Update to your desired SQL pool name
//   default     = "sqlpoolname"
// }
// 
// variable "workspace_name" {
//   description = "Synapse Workspace Name for Azure"
//   # Update to your desired Synapse workspace name
//   default     = "workspacename"
// }
// 