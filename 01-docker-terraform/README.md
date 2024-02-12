wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz


--------------------------
docker run -it -e POSTGRES_USER="root" -e POSTGRES_PASSWORD="root" -e POSTGRES_DB="ny_taxi" -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgres/data -p 5432:5432 postgres:13


*-------------------------- *
>>>>>>>  START HERE  <<<<<<<<<<
# Set up the environment dependencies
docker volume create --name ny_taxi_postgres_data
docker network create pg-network

# Run the Database Server
docker run -it   -e POSTGRES_USER="root"   -e POSTGRES_PASSWORD="root"   -e POSTGRES_DB="ny_taxi"    -v "$(pwd)/ny_taxi_postgres_data:/var/lib/postgres/data"   -p 5432:5432   --network=pg-network   --name pg-database   postgres:13

# Run the Admin Server
docker run -it   -e PGADMIN_DEFAULT_EMAIL="admin@admin.com"   -e PGADMIN_DEFAULT_PASSWORD="root"   -p 8080:80   --network=pg-network   --name pgadmin  dpage/pgadmin4

# another way to run the Admin Server (codespaces) if you're getting CSRF errors
docker run --rm -it -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" -e PGADMIN_DEFAULT_PASSWORD="root"  -e PGADMIN_CONFIG_WTF_CSRF_ENABLED="False"     -p "8080:80"  --name pgadmin  --network=pg-network  dpage/pgadmin4:8.2


--------------------------
pgcli -h localhost -p 5432 -u root -d ny_taxi
sudo chmod a+rwx ny_taxi_postgres_data

# here is another one:
docker network ls #to find the network name, 'network 2_docker_sql_default' in this case
docker run -it --rm --network 2_docker_sql_default ai2ys/dockerized-pgcli:4.0.1
pgcli -h pgdatabase -p 5432 -u root -d ny_taxi

---------

URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"
docker run -it   --network=pg-network   taxi_ingest:v001     --user=root     --password=root     --host=pg-database     --port=5432     --db=ny_taxi     --table_name=yellow_taxi_trips     --url=${URL}

-----------
URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"
python ingest_data.py --user=root --password=root --host=localhost --port=5432 --db=ny_taxi --table_name=yellow_taxi_trips --url=${URL}

*--------------------------*
# INGESTION
docker build -t taxi_ingest:v001 .

URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"

URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-09.csv.gz"

docker run -it --network=pg-network taxi_ingest:v001 --user=root --password=root --host=pg-database --port=5432 --db=ny_taxi --table_name=yellow_taxi_trips --url=${URL}

#-------------------
# python -m http.server
# ifconfig to get IP Address of your local machine
# http://172.27.190.170:8000/
#----------
URL="http://172.27.190.170:8000/yellow_tripdata_2021-01.csv"

docker run -it \
  --network=pg-network \
  taxi_ingest:v001 \
    --user=root \
    --password=root \
    --host=pg-database \
    --port=5432 \
    --db=ny_taxi \
    --table_name=yellow_taxi_trips \
    --url=${URL}

# the lookup table  DOESN'T WORK YET  load it jupyter for now
URL=https://d37ci6vzurychx.cloudfront.net/misc/taxi+_zone_lookup.csv
docker run -it --network=2_docker_sql_default taxi_ingest:v001 --user=root --password=root --host=localhost --port=5432 --db=ny_taxi --table_name=zones --url=${URL}



#####################################################
# INGESTION
if using docker-compose, look for the docker-compose network in the startup and use that one

docker run -it taxi_ingest:v001 --network=construction_default --user=root --password=root --host=localhost --port=5432 --db=ny_taxi --table_name=yellow_taxi_trips --url=${URL}



#####################################################
# Exploring the Data
#
# find the latest pickup time, earliest pickup time and largest fare in the database
SELECT max(tpep_pickup_datetime), min(tpep_pickup_datetime),max(total_amount) FROM yellow_taxi_trips;





docker volume create --name dtc_postgres_volume_local -d local

--------------------
SQL Notes 1 / 3

SELECT
  *
FROM
  zones;
  
SELECT
  *
FROM
  yellow_taxi_data
LIMIT 100;

-- Inner Join #1 using WHERE
-- only returns where id's in both tables are present
SELECT
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  total_amount,
  CONCAT(zpu."Borough", ' / ', zpu."Zone") AS "pick_up_loc",
  CONCAT(zdo."Borough", ' / ', zdo."Zone") AS "drop_off_loc"  
FROM
  yellow_taxi_data t,
  zones zpu,
  zones zdo
WHERE
  t."PULocationID" = zpu."LocationID" AND
  t."DOLocationID" = zdo."LocationID"  
LIMIT 100;
  
-- Inner Join #2 using JOIN syntax
-- only returns where id's in both tables are present
SELECT
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  total_amount,
  CONCAT(zpu."Borough", ' / ', zpu."Zone") AS "pick_up_loc",
  CONCAT(zdo."Borough", ' / ', zdo."Zone") AS "drop_off_loc"  
FROM
  yellow_taxi_data t JOIN zones zpu
    ON t."PULocationID" = zpu."LocationID"
  JOIN zones zdo
    ON t."DOLocationID" = zdo."LocationID"
LIMIT 100;


--------------------
SQL Notes 2 / 3

-- Find records without matching Zones

SELECT
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  total_amount,
  "PULocationID",
  "DOLocationID"
FROM
  yellow_taxi_data t
WHERE 
  "PULocationID" is NULL OR
  "DOLocationID" is NULL
LIMIT 100;


-- Find any Pickup or Dropoff Locations in yellow_taxi_data 
-- that are not present in Zones table

SELECT
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  total_amount,
  "PULocationID",
  "DOLocationID"
FROM
  yellow_taxi_data t
WHERE 
  "PULocationID" NOT IN (SELECT "LocationID" FROM zones) OR
  "DOLocationID" NOT IN (SELECT "LocationID" FROM zones)
LIMIT 100;


-- let's delete a zone and run the above query again
SELECT * from ZONES WHERE "LocationID" = 142;
DELETE FROM zones WHERE "LocationID" = 142;


-- LEFT Join using JOIN syntax
-- shows NULL when id's in LEFT (yellow_taxi_data)
-- is not present on the RIGHT (zones)
SELECT
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  total_amount,
  CONCAT(zpu."Borough", ' / ', zpu."Zone") AS "pick_up_loc",
  CONCAT(zdo."Borough", ' / ', zdo."Zone") AS "drop_off_loc"  
FROM
  yellow_taxi_data t LEFT JOIN zones zpu
    ON t."PULocationID" = zpu."LocationID"
  LEFT JOIN zones zdo
    ON t."DOLocationID" = zdo."LocationID"
LIMIT 100;

-- RIGHT Join using RIGHT JOIN syntax
-- shows NULL when id's in RIGHT (zones)
-- is not present on the LEFT (yellow_taxi_data)
SELECT
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  total_amount,
  CONCAT(zpu."Borough", ' / ', zpu."Zone") AS "pick_up_loc",
  CONCAT(zdo."Borough", ' / ', zdo."Zone") AS "drop_off_loc"  
FROM
  yellow_taxi_data t RIGHT JOIN zones zpu
    ON t."PULocationID" = zpu."LocationID"
  RIGHT JOIN zones zdo
    ON t."DOLocationID" = zdo."LocationID"
LIMIT 100;

-- OUTER Join using OUTER JOIN syntax  THIS NEEDS WORK
-- shows NULL when id's in RIGHT (zones)
-- OR the LEFT (yellow_taxi_data) is not present 
SELECT
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  total_amount,
  CONCAT(zpu."Borough", ' / ', zpu."Zone") AS "pick_up_loc",
  CONCAT(zdo."Borough", ' / ', zdo."Zone") AS "drop_off_loc"  
FROM
  yellow_taxi_data t OUTER JOIN zones zpu
    ON t."PULocationID" = zpu."LocationID"
  OUTER JOIN zones zdo
    ON t."DOLocationID" = zdo."LocationID"
LIMIT 100;






--------------------
SQL Notes 3 / 3

-- GROUP BY Date
SELECT
  CAST(tpep_dropoff_datetime AS DATE) as "day",
  COUNT(1)
FROM
  yellow_taxi_data t 
GROUP BY
  CAST(tpep_dropoff_datetime AS DATE)
ORDER BY "day" ASC;

-- GROUP BY Count
SELECT
  CAST(tpep_dropoff_datetime AS DATE) as "day",
  COUNT(1) as "count"
FROM
  yellow_taxi_data t 
GROUP BY
  CAST(tpep_dropoff_datetime AS DATE)
ORDER BY "count" DESC;


-- GROUP BY multiple columns
SELECT
  CAST(tpep_dropoff_datetime AS DATE) as "day",
  "DOLocationID",
  COUNT(1) as "count",
  MAX(total_amount) as "amount",
  MAX(passenger_count) as "passenger_count"
FROM
  yellow_taxi_data 
GROUP BY
  CAST(tpep_dropoff_datetime AS DATE),
  "DOLocationID"
ORDER BY 
  "day" ASC,
  "DOLocationID" ASC;
  
  
  -- GROUP BY multiple columns
SELECT
  CAST(tpep_dropoff_datetime AS DATE) as "day",
  "DOLocationID",
  COUNT(1) as "count",
  MAX(total_amount) as "amount",
  MAX(passenger_count) as "passenger_count"
FROM
  yellow_taxi_data 
GROUP BY
  1, 2
ORDER BY 
  "count" DESC,
  "DOLocationID" ASC;
  



  TERRAFORM

https://cloud.google.com/compute/docs/connect/standard-ssh#provide-key
https://cloud.google.com/compute/docs/connect/create-ssh-keys
https://cloud.google.com/compute/docs/connect/add-ssh-keys


********  Generate ssh key  ********  
cd ..ssh
ssh-keygen -t rsa -f ~/.ssh/gcp -C jschulle -b 2048
<no passphrase>


********  add it to metadata in GCP  ******
Copy and Paste the gcp.pub (can be copied/shared) to ssh keys in the GCE Settings>Metadata in Google cloud.  All the VM's that you create will inherit this key.
https://console.cloud.google.com/compute/metadata?authuser=4&project=inspired-victor-409616&tab=sshkeys

********  configure the ssh client  *******

cat /Users/jschulle/.ssh/config
Host de-zoomcamp
    HostName 34.30.124.145
    User jschulle
    IdentityFile /Users/jschulle/.ssh/gcp

Host 127.0.0.1
    HostName 127.0.0.1
    Port 2222
    User joshua.schuller
    IdentityFile /home/jschulle/.ssh/id_rsa

ssh -i ~/.ssh/gcp jschulle@<vm_server_ip>
ssh jschulle@de-zoomcamp
ssh de-zoomcamp

In VSCODE, check the SSH extension settings for the path to Users/jschulle/.ssh/config


----------------
On the VM 
----------------
Install 
  wget Anaconda3-2023.09-0-Linux-x86_64.sh
  bash Anaconda3-2023.09-0-Linux-x86_64.sh
  run conda initializer

sudo apt-get update
sudo apt-get install docker.io
execute the commands to run docker without sudo
    https://github.com/sindresorhus/guides/blob/main/docker-without-sudo.md
docker run -it ubuntu bash

mkdir bin; cd bin
wget https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-linux-x86_64 -O docker-compose
chmod +x docker-compose
docker-compose version

edit .bashrc
export PATH="${HOME}/bin:{PATH}"

git clone https://github.com/DataTalksClub/data-engineering-zoomcamp.git
cd /home/jschulle/data-engineering-zoomcamp/week_1_basics_n_setup/2_docker_sql
docker-compose up -d

pip install pgcli
pgcli -h localhost -p 5432 -u root -d ny_taxi
/dt
pip uninstall pgcli

conda install -c conda-forge pgcli
pgcli -h localhost -p 5432 -u root -d ny_taxi

in VSCODE, you can add tcp 5432 to forward to local machine
then access postgres using pgcli on local computer

in VSCODE, you can add tcp 8080 to forward to local machine
then access pgadmin using browser https://localhost:8080

On Google VM Server, 
cd /home/jschulle/data-engineering-zoomcamp/week_1_basics_n_setup/2_docker_sql
jupyter notebook 
in VSCODE, you can add tcp 8888 to forward to local machine
then access JUPYTER using browser https://localhost:8080
and run the upload-data.ipynb

cd bin
wget https://releases.hashicorp.com/terraform/1.7.0/terraform_1.7.0_linux_amd64.zip
sudo ap-get install unzip
cd /home/jschulle/data-engineering-zoomcamp/week_1_basics_n_setup/1_terraform_gcp/

On local machine
 cd /Users/jschulle/.config/gcloud
 sftp de-zoomcamp 
 mkdir .gc
 cd .gc
 put ny_rides.json

in .bashrc
export GOOGLE_APPLICATION_CREDENTIALS="/home/jschulle/.gc/ny_rides.json"

#authenticate to the the Google CLI
 gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS

NOW you can do terraform
cd /home/jschulle/data-engineering-zoomcamp/week_1_basics_n_setup/2_docker_sql
terraform init 
terraform plan


----------------
GOOGLE CLOUD SDK 
----------------
Installed SDK
Added to env var to  .zshrc 
   export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.config/gcloud/ny_rides.json"








# Week-1
Tech stacks:
- Postgres
- pgAdmin
- Docker
- Terraform
- GCP: Cloud Storage and BigQuery

Steps:
1. Turn on the VM and get the external IP
2. Place the IP to `config` file in `.ssh` folder
3. Connect VM via SSH in VSCode (suggested) or CMD via `ssh de-zoomcamp` as `config` file
4. Navigate to the VM directory 
5. Setup docker-compose with `docker-compose up -d`
6. Add necessary port to forward (e.g. 5432 for Postgres, 8080 for pgAdmin, 8888 for Jupyter Notebook)
6. Quick check to Postgres via local with activated .venv `pgcli -h localhost -p 5432 -u root -d ny_taxi`
7. Detailed check to Postgress via pgAdmin in localhost:8080
8. Terraform setup and apply