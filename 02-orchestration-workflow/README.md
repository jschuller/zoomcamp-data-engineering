>>>>>>>>>>>  CONFIGURING MAGE  <<<<<<<
https://www.youtube.com/watch?v=tNiV7Wp08XE

git clone https://github.com/mage-ai/mage-ai

cp env .env
docker compose build

# If you see the Update Now button in Mage UI, then run this:
docker pull mageai/mageai:latest

docker compose up


----------
# >>> GCP Notes <<<
https://www.youtube.com/watch?v=00LP360iYvE&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=23&pp=iAQB

1) Create storage account

2) Create Service Account ('owner' role permissions - liberal permissions but works ;) 
3) Download JSON security key and copy it to the Mage project directory
  - note that it has docker-compose.yaml has this volume mapped
  volumes:
      - .:/home/src/
4) Editing io_config.yaml in Mage:   
  - note that you can go to the terminal (in Mage) and find the Key in the base dir, /home/src
  - Update 'io_config.yaml' e.g. 
        GOOGLE_SERVICE_ACC_KEY_FILEPATH: "/home/src/project_service_account_key.json"
5) Now we can go edit the Mage pipeline, test_config 
  - change the datasource from PostGres to BigQuery
  - change the Profile from 'dev' back to 'default'
    # Raised Exception, 'At least 1 of the tables must contain: database.dataset.table'
6) Test file storage access
  - Mage has an 'example_pipeline' with a Data Exporter that Loads, Transforms and Writes titanic_clean.csv to the local filesystem (look in VC Code)
  - Create a Google Cloud Storage bucket (e.g. mage-zoomcamp-josh-schuller ) and upload titanic_clean.csv
  - Back in the 'test_config' pipeline in Mage, add a new Data Loader e.g. 'test_gcs'
  - Update the following lines like so:
      bucket_name = 'mage-zoomcamp-josh-schuller'
      object_key = 'titanic_clean.csv'
  - this should run ok, returning a pandas dataframe from GCS  :)

---------------
# >>>  DE Zoomcamp 2.2.4 - ETL: API to GCS  <<<
>>> https://www.youtube.com/watch?v=w0XmcASRUnc&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=24

## Now we are going to write the data to GCS (Google Cloud Storage) location instead of local filesystem (and the manual copy as above).

1) In Mage, create a new batch pipeline
2) From the file explorer on the left, under the magic-zoomcamp base directory navigate to 'data_loaders' and drag in the 'load_api_data.py' block.
3) Also under 'transformers' drag over  'transform_taxi_data.py' (clean_taxi_data.py).
4) Connect data_loader and the transformer blocks in the "Tree" view
5) Add a new Data Exporter (Python->Google Cloud Storage) named 'taxi_to_gcs_parquet'
  - Update the following lines like so:
      bucket_name = 'mage-zoomcamp-josh-schuller'
      object_key = 'object_key = 'nyc_taxi_data.parquet'
6) 'Execute with all upstream blocks' and confirm file is in the bucket

# That was one Parquet file, now let's partition by some column (e.g. date)to handle bigger data use cases
1) In our same 'taxi_to_gcs_parquet' pipeline, add a new Data exporter (Python, Generic (No Template)) named 'taxi_to_gcs_partitioned_parquet'
2) Remove the connection and add a new connection from 'transform_taxi_data' to 'taxi_to_gcs_partitioned_parquet' so it runs in parallel with 'taxi_to_gcs_parquet'
3) Define credentials (manually) and use the pyarrow library to parition this dataset 
  - pyarrow is was included in the docker image and should be available by default
  - Mage will use credentials in the 'io_config.yaml' but in this case we are setting manually (location can be determnined in Mage terminal): 
        os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = "/home/src/project_service_account_key.json"
        bucket_name = 'mage-zoomcamp-josh-schuller'
        # object_key = 'nyc_taxi_data.parquet'
        project_id = ''
        table_name = "nyc_taxi_data"
        root_path = f'{bucket_name}/{table_name}'
  - under the @data_exporter, let's create a date column since we only have a date/time column.

        @data_exporter
        def export_data(data, *args, **kwargs):
            data['tpep_pickup_date'] = data['tpep_pickup_datetime'].dt.date

            # Pyarrow need this
            table = pa.Table.from_pandas(data)

            gcs = pa.fs.GcsFileSystem()

            #write it to the dataset
            pq.write_to_dataset(
                table,
                root_path=root_path,
                partition_cols=['tpep_pickup_date'],
                filesystem=gcs
            )

4)  Partioning the data by date (as above) has a lot of advantages over trying to read/write data to one 2GB file (for example).  One benefit of pyarrow is that it abstracts away the need to data chunking


-------------------------------------------------------
# DE Zoomcamp 2.2.5 - ETL: GCS to BigQuery 
https://www.youtube.com/watch?v=JKp_uzM-XsM&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=25

## We are going to continue setting up the traditional data engineering workflow where we take the data from some external data source, stage on cloud storage and then ingest it into a database.

1) Create a new pipeline (Standard Batch) named 'gcs_to_big_query'
2) Create a block, Data Loader>Python>Google Cloud Storage  called 'load_taxi_gcs'
  -  Add the following (this is the unpartitioned way but this could be changed to use partioned with pyarrow as above)

    bucket_name = 'mage-zoomcamp-josh-schuller'
    object_key = 'nyc_taxi_data.parquet'

  - should return a dataset

3) Add new Block, Transformer, Python (Generic) named 'transform_staged_data'.  Another best practice is to standardize column names.  The taxi data columns are not consistent with capitalization, etc.

    @transformer
    def transform(data, *args, **kwargs):
        data.columns = (data.columns
                        .str.replace(' ', '_')
                        .str.lower()
        )
    
        return data

4) Add a new SQL data export named, "write_taxi_to_bigquery"
  - Choose 
      Connection = BigQuery
      Profile = default
      Database (leave default)
      Schema=ny_taxi
      Table=yellow_cab_data
  
  - cool thing about Mage is that you can select directly from dataframes.  the previous block, 'transform_staged_data' is going to return df_1
     Example: SELECT * FROM {{ df_1 }} to insert all rows from transform_staged_data into a table.

  - So we will 
        SELECT * FROM {{ df_1 }}
  - to select all the rows from the previous block and export to 'ny_taxi.yellow_cab.data'

5) confirm the dat ais in BigQuery under the project (e.g. nspired-victor-409616, ny_taxi, yellow_cab_data)

6) Now we SCHEDULE (Mage is an orchestrator after all :)
   - Go to Pipelines > gcs_to_big_query > triggers
   - Create a trigger named, "gcs_to_big_query_schedule" with a Trigger Type = Schedule
   - Enable Trigger (should you want to)


---------------
# >>> DE Zoomcamp 2.2.6 - Parameterized Execution  <<<
>>> https://www.youtube.com/watch?v=H0hWjWxB-rg&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=26
## loading datasets/partial datasets that depend on certain parameters, AKA Parameterized Execution.

1) Go to Pipelines, right click on a pipeline (e.g. 'load_to_gcp') and Clone
2) Delete the Advanced block
3) Rename pipeline to 'export_taxi_gcp_parameter'
4) Ok so copy the code from 'export_taxi_to_gcp_basic'
   - Create a new Data exporter> Python Generic Template and paste in the above code
   - remove the connections to the Exporters and delete 'export_taxi_to_gcp_basic', reconnect
   # NOTE:  modying the blocks directly will update them on all pipelines where they are used.  so we are copying code to a new block so can extend/modify the code without impacting other pipelines
5) Rename the pipeline to 'load_to_gcp_parameter'
6) ... some good stuff about 

    @data_exporter
    def export_data_to_google_cloud_storage(df: DataFrame, **kwargs) -> None:
        """
        Template for exporting data to a Google Cloud Storage bucket.
        Specify your configuration settings in 'io_config.yaml'.
    
        Docs: https://docs.mage.ai/design/data-loading#googlecloudstorage
        """
    
        now = kwargs.get('execution_date')
        now_fpath = now.strftime("%Y/%m/%d") # file path to use in object key
    
        #print(now) # e.g. 2024-01-28 20:09:10.488690
        #print(now.date()) # e.g. 2024-01-28
        #print(now.day) # e.g. 3
        #print(now.strftime("%Y/%m/%d")) # e.g. 2024/01/03
    
    
    
        config_path = path.join(get_repo_path(), 'io_config.yaml')
        config_profile = 'default'
    
        bucket_name = 'mage-zoomcamp-josh-schuller'
        object_key = f'{now_fpath}/daily_trips.parquet'
        #print(object_key)  # e.g. 2024/01/28/daily_trips.parquet
    
        GoogleCloudStorage.with_config(ConfigFileLoader(config_path, config_profile)).export(
            df,
            bucket_name,
            object_key,
        )

-------------------------------------------------------
# >>> DE Zoomcamp 2.2.6 - Backfills
https://www.youtube.com/watch?v=ZoeC6Ag5gQc&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=27

## This about using Mage features to re-run data for particular days, e.g. in the event it was lost or had an issue

1) In a Pipeline, navigate to the Backfills tab on the sidebar
2) Settings
  Backfill name: magic-zoomcamp-backfill
  Start date and time: 2024-01-01 00:00
  End date and time: 2024-01-07 00:00
  Interval Type:Day
  Interval Unit:1
3) >>>Takeaway:  Quick and easy way to backfill data if you are using parameterized runs<<<

-------------------------------------------------------
# >>> DE Zoomcamp 2.2.7 - Deployment Prerequisites  
https://www.youtube.com/watch?v=zAwAX5sxqsg&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=28

## Deploying Mage to Google Cloud with Terraform

1) Prerequisites

2) Google Cloud Permissions
  Go to IAM and add these roles (from the project permissions page)
   - artifact registry read
   - artifact registry write
   - google cloud run developer
   - cloud sql admin
   - service account token creator

3) gcloud cli
   - verify ggogle cloud cli is installed on the command line
     gcloud auth list
     gcloud storage ls


4) Terraform
   - git clone https://github.com/mage-ai/mage-ai-terraform-templates.git
   - cd mage-ai-terraform-templates  # terraform templates already exist for each cloud provider
   - cd gcp
   - code .

5) RUN TERRAFORM
    back in vs code terminal,  terraform apply

6) After deploying the terraform stack, you need to whitelist IP to access the URL.  Fo to Google Cloud Run > Networking tab and adjust.  (you can open it up to everyone/All but... )

7) Now we  have a NEW MAGE INSTANCE. It's a blank slate, the best way to bring in our code is using git
    Mage has some features "git sync" in the left hand nav

8) Shut it down so you don't get a bill
    back in vs code terminal,  terraform destroy  # you need the postgres password defined

9) 

------------------


# Week-2
Tech stacks:
- Postgres
- pgAdmin
- Mage
- Docker
- Terraform
- GCP: Cloud Storage 

Steps:
1. Prepare VM SSH connection in VS Code, navigate to the project directory
2. Setup docker-compose.yml and Dockerfile for Postgres, pgAdmin, and Mage
3. Setup terraform files to create bucket in GCS
4. `docker-compose up -d` and forward the ports in VS Code
5. `terraform apply` for needed infra
5. Creating pipeline `green_taxi_etl` in Mage as instructed