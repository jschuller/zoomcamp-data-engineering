# Use this if you do not want to set env-var GOOGLE_APPLICATION_CREDENTIALS
// variable "credentials" { 
//   description = "My Credentials"
//   default     = "<Path to your Service Account json file>"
//  # Path to your Service Account json file  
//  # ex. default = "./keys/my-creds.json"
// }

# Use this if you do not want to set env-var GOOGLE_APPLICATION_CREDENTIALS
variable "credentials" {
  description = "My Credentials"
  default     = "/Users/jschulle/.gcp/inspired-victor-409616-5d95f959b863.json"
  # Path to your Service Account json file  
  # ex. default = "./keys/my-creds.json"
}

variable "project" {
  description = "Project"
  # Update to your GCP Project ID or remove to specify on cmd line (terraform plan)
  default     = "inspired-victor-409616"
}

variable "region" {
  description = "Region"
  #Update the below to your desired region. https://cloud.google.com/about/locations
  default     = "us-central1-a"
}

variable "location" {
  description = "Project Location"
  #Update the below to your desired location
  default     = "us-central1"
}

variable "bq_dataset_name" {
  description = "BigQuery Dataset Name for Week-3 Homework"
  #Update the below to what you want your dataset to be called
  default     = "week_3_hw_dataset_jschuller"
}

variable "gcs_bucket_name" {
  description = "Storage Bucket Name for Week-3 Homework"
  #Update the below to a unique bucket name
  default     = "week-3-hw-bucket-jschuller"
}

variable "gcs_bucket_dir_name" {
  description = "Storage Bucket Directory Name for Week-3 Homework"
  default     = "green-tripdata-2022/"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}