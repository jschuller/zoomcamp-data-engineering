# Week-4
Tech stacks:
- dbt
- Bash Script
- Terraform
- GCP: Cloud Storage and BigQuery 

Data:
[NYC Green Taxi 2022](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page) 

Steps:
1. Prepare VM SSH connection in VS Code, navigate to the project directory
2. Setup Terraform to manage GCS bucket and BigQuery dataset, and create folder in GCS bucket for the files
3. Create `raw_data_urls.txt` and `download_raw_data.sh`, then give permission `chmod +x download_raw_data.sh` to download parquet data into GCS folder (See [reference-1](https://github.com/toddwschneider/nyc-taxi-data/tree/master) and [reference-2](https://stackoverflow.com/questions/55524999/is-there-any-terraform-module-to-create-folders-within-a-bucket-gcp)), and execute 
4. Move to BigQuery then create tables as needed

5. Setup dbt cloud account, BQ service account, github repo linking, and project for dbt (See [reference](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/04-analytics-engineering/dbt_cloud_setup.md)) 
6. Initialize project in dbt IDE 
