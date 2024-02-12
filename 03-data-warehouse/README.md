### Terraform Side Quest: Multi-cloud Azure

| Comments | GCP | Azure | AWS |
| ------------- |:-------------:|-------------:|-------------:|
| Storage bucket resource | `google_storage_bucket` | `azurerm_storage_account`| `aws_s3_bucket` |
| Object/blob stored in bucket | `google_storage_bucket_object`| `azurerm_storage_blob`| `aws_s3_bucket_object` |
| Analytics database resource | `google_bigquery_dataset`| `azurerm_synapse_spark_pool` | `aws_glue_catalog_database` |   
| Region/location attribute | `location`| `location`| `region` |
| Force delete bucket if not empty | `force_destroy` | N/A | `force_destroy` |
| Rules for object lifecycle management | `lifecycle_rule` | N/A | `lifecycle_rule` |
| Name/ID attribute | `dataset_id`| `name` | Varies |  
| Object content attribute | `content`| `content` | `content` |
| Bucket name attribute | `bucket`| `storage_account_name` | `bucket` |
| Container/prefix attribute | `prefix` | `container_name` | N/A |


Data:
[NYC Green Taxi 2022](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page) 


# Week-3
Tech stacks:
- Bash Script
- Terraform
- GCP: Cloud Storage and BigQuery 

Steps:
1. Prepare VM SSH connection in VS Code, navigate to the project directory
2. Setup Terraform to manage GCS bucket and BigQuery dataset, and create folder in GCS bucket for the files
3. Create `raw_data_urls.txt` and `download_raw_data.sh`, then give permission `chmod +x download_raw_data.sh` to download parquet data into GCS folder (See [reference-1](https://github.com/toddwschneider/nyc-taxi-data/tree/master) and [reference-2](https://stackoverflow.com/questions/55524999/is-there-any-terraform-module-to-create-folders-within-a-bucket-gcp)), and execute 
4. Move to BigQuery then create tables as needed