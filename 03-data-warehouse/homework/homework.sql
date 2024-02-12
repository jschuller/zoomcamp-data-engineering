-- SETUPS
CREATE OR REPLACE EXTERNAL TABLE `inspired-victor-409616.week_3_hw_dataset_jschuller.green_tripdata_2022`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://week-3-hw-bucket-jschuller/green-tripdata-2022/green_tripdata_2022-*.parquet']
);

CREATE OR REPLACE TABLE `inspired-victor-409616.week_3_hw_dataset_jschuller.green_tripdata_2022_nonpartitioned`
AS SELECT * FROM `inspired-victor-409616.week_3_hw_dataset_jschuller.green_tripdata_2022`;

-- QUESTION 1
SELECT count(*) FROM `inspired-victor-409616.week_3_hw_dataset_jschuller.green_tripdata_2022`;
-- ANSWER: 840,402

-- QUESTION 2
SELECT COUNT(DISTINCT(PULocationID)) FROM `inspired-victor-409616.week_3_hw_dataset_jschuller.green_tripdata_2022`;
-- ANSWER: This query will process 0 B when run.
SELECT COUNT(DISTINCT(PULocationID)) FROM `inspired-victor-409616.week_3_hw_dataset_jschuller.green_tripdata_2022_nonpartitioned`;
-- ANSWER: This query will process 6.41 MB when run.


-- QUESTION 3
SELECT SUM(IF(fare_amount=0, 1, 0)) FROM `inspired-victor-409616.week_3_hw_dataset_jschuller.green_tripdata_2022`;
-- ANSWER: 1622

-- QUESTION 4
CREATE OR REPLACE TABLE `inspired-victor-409616.week_3_hw_dataset_jschuller.green_tripdata_2022_partitioned`
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY PUlocationID AS (
  SELECT * FROM `inspired-victor-409616.week_3_hw_dataset_jschuller.green_tripdata_2022`
);
-- ANSWER: Partition by lpep_pickup_datetime and cluster by PUlocationID

-- QUESTION 5
SELECT DISTINCT PULocationID FROM  `inspired-victor-409616.week_3_hw_dataset_jschuller.green_tripdata_2022_nonpartitioned`
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30'
-- ANSWER: This query will process 12.82 MB when run. 

SELECT DISTINCT PULocationID FROM  `inspired-victor-409616.week_3_hw_dataset_jschuller.green_tripdata_2022_partitioned`
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30'
-- ANSWER: This query will process 1.12 MB when run.

-- QUESTION 6
-- ANSWER: GCP Bucket

-- QUESTION 7
-- ANSWER: True