Module 1 Homework
Docker & SQL

In this homework we'll prepare the environment and practice with Docker and SQL
Question 1. Knowing docker tags

Run the command to get information on Docker

docker --help

Now run the command to get help on the "docker build" command:

docker build --help

Do the same for "docker run".

Which tag has the following text? - Automatically remove the container when it exits

    --delete
    --rc
    --rmc
    --rm

>>>>>  --rm 

Question 2. Understanding docker first run

Run docker with the python:3.9 image in an interactive mode and the entrypoint of bash. Now check the python modules that are installed ( use pip list ).

What is version of the package wheel ?

    0.42.0
    1.0.0
    23.0.1
    58.1.0


>>>>>>  docker run -it --rm  --entrypoint bash python:3.9
>>>>>   wheel      0.42.0

Prepare Postgres

Run Postgres and load data as shown in the videos We'll use the green taxi trips from September 2019:

wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-09.csv.gz

You will also need the dataset with zones:

wget https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv

Download this data and put it into Postgres (with jupyter notebooks or with a pipeline)



Question 3. Count records

How many taxi trips were totally made on September 18th 2019?

Tip: started and finished on 2019-09-18.

Remember that lpep_pickup_datetime and lpep_dropoff_datetime columns are in the format timestamp (date and hour+min+sec) and not in date.

    15767
    15612
    15859
    89009


>>> 15612
>>> SELECT
>>>   DATE(lpep_dropoff_datetime) AS dropoff_day,
>>>   DATE(lpep_pickup_datetime) AS pickup_day,
>>>   COUNT(*)
>>> FROM green_taxi_data
>>> WHERE
>>>   CAST(lpep_pickup_datetime AS DATE) = DATE '2019-09-18' AND CAST(lpep_dropoff_datetime AS DATE) = '2019-09-18'
>>> GROUP BY
>>>   dropoff_day,
>>>     pickup_day
>>> ORDER BY
>>>   pickup_day ASC;




Question 4. Largest trip for each day

Which was the pick up day with the largest trip distance Use the pick up time for your calculations.

    2019-09-18
    2019-09-16
    2019-09-26
    2019-09-21

>>> SELECT
>>>   DATE(lpep_pickup_datetime) AS pickup_day,
>>>   trip_distance
>>> FROM green_taxi_data  
>>> ORDER BY trip_distance DESC
>>> LIMIT 10;

>>>  2019-09-26



Question 5. Three biggest pick up Boroughs

Consider lpep_pickup_datetime in '2019-09-18' and ignoring Borough has Unknown,  Which were the 3 pick up Boroughs that had a sum of total_amount superior to 50000?

    "Brooklyn" "Manhattan" "Queens"
    "Bronx" "Brooklyn" "Manhattan"
    "Bronx" "Manhattan" "Queens"
    "Brooklyn" "Queens" "Staten Island"

>>> SELECT 
>>>   zpu."Borough" AS pickup_borough,
>>>   SUM(t.total_amount) AS total_amount
>>> FROM green_taxi_data t
>>> JOIN zones zpu ON t."PULocationID" = zpu."LocationID"
>>> WHERE DATE(t.lpep_pickup_datetime) = '2019-09-18'
>>>   AND zpu."Borough" != 'Unknown'  
>>> GROUP BY zpu."Borough"
>>> ORDER BY SUM(t.total_amount) DESC
>>> LIMIT 3;
>>>
>>> "Brooklyn" "Manhattan" "Queens"


Question 6. Largest tip

For the passengers picked up in September 2019 in the zone name Astoria which was the drop off zone that had the largest tip? We want the name of the zone, not the id.

Note: it's not a typo, it's tip , not trip

    Central Park
    Jamaica
    JFK Airport
    Long Island City/Queens Plaza

>>> 
>>> one" AS drop_off_zone,
>>> p_amount) AS max_tip 
>>> en_taxi_data t
>>> es zpu ON t."PULocationID" = zpu."LocationID"  
>>> es zdo ON t."DOLocationID" = zdo."LocationID"
>>> u."Zone" = 'Astoria'
>>> TE_TRUNC('month', t.lpep_pickup_datetime) = DATE '2019-09-01'
>>>  zdo."Zone"
>>>  MAX(tip_amount) DESC
>>> 
>>> JFK Airport


Terraform

In this section homework we'll prepare the environment by creating resources in GCP with Terraform.
In your VM on GCP/Laptop/GitHub Codespace install Terraform. Copy the files from the course repo here to your VM/Laptop/GitHub Codespace.
Modify the files as necessary to create a GCP Bucket and Big Query Dataset.

Question 7. Creating Resources
After updating the main.tf and variable.tf files run:

terraform apply

Paste the output of this command into the homework submission form.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

google_bigquery_dataset.dataset: Creating...
google_storage_bucket.data-lake-bucket: Creating...
google_storage_bucket.data-lake-bucket: Creation complete after 1s [id=dtc_data_lake_inspired-victor-409616]
google_bigquery_dataset.dataset: Creation complete after 1s [id=projects/inspired-victor-409616/datasets/trips_data_all]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
(base) jschulle@de-zoomcamp:~/data-engineering-zoomcamp/week_1_basics_n_setup/1_terraform_gcp/terraform$ 


>>> 