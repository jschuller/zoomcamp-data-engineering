# Homework

Codes or commands to answer questions for homework

## Question 1: What is count of records for the 2022 Green Taxi Data??

### Answer

**solution**: - `840402`

## Question 2. Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.  What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?

### Answer 

**solution**: - `0 MB for the External Table and 6.41MB for the Materialized Table`

## Question 3. How many records have a fare_amount of 0?

### Answer 

**solution**: - `1622`

## Question 4. What is the best strategy to make an optimized table in Big Query if your query will always order the results by PUlocationID and filter based on lpep_pickup_datetime? (Create a new table with this strategy)

### Answer 

**solution**: - `Partition by lpep_pickup_datetime Cluster on PUlocationID`

## Question 5. What's the size of the tables?

### Answer 

**solution**: - `12.82 MB for non-partitioned table and 1.12 MB for the partitioned table`

## Question 6. Where is the data stored in the External Table you created?

### Answer 

**solution**: - `GCP Bucket`

## Question 7. It is best practice in Big Query to always cluster your data: True or False?

### Answer 

**solution**: - `True:  https://cloud.google.com/bigquery/docs/clustered-tables`

