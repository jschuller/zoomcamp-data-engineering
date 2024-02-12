variable "credentials" {
  description = "My Credentials"
  default     = "/home/docksgit/.gcp/de-zoomcamp-key.json"
}

variable "project" {
  description = "Project"
  default     = "hardy-portal-411910"
}

variable "region" {
  description = "Region"
  #Update the below to your desired region
  default     = "asia-southeast2-a"
}

variable "location" {
  description = "Project Location"
  #Update the below to your desired location
  default     = "ASIA-SOUTHEAST2"
}

variable "bq_dataset_name" {
  description = "BigQuery Dataset Name for Week-1 Homework"
  #Update the below to what you want your dataset to be called
  default     = "week_1_hw_dataset"
}

variable "gcs_bucket_name" {
  description = "Storage Bucket Name for Week-1 Homework"
  #Update the below to a unique bucket name
  default     = "week-1-hw-bucket"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}