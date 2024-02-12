# Homework

Codes or commands to answer questions for homework

1. Commands:
`docker run --help`\
`--rm    Automatically remove the container when it exits`

2. Dockerfile:
```
FROM python:3.9
ENTRYPOINT [ "bash" ]
```

Commands:
`docker build -t python:3.9 .`\
`docker run -it python:3.9`\
`pip list`\
`wheel      0.42.0`

3. SQL Code:
```
SELECT count(*)
FROM public.green_taxi_data
WHERE date(lpep_pickup_datetime) = '2019-09-18' 
AND date(lpep_dropoff_datetime) = '2019-09-18'
```

4. SQL Code:
```
SELECT date(lpep_pickup_datetime)
FROM public.green_taxi_data
WHERE trip_distance = (
	SELECT MAX(trip_distance)
	FROM public.green_taxi_data
)
```

5. SQL Code:
```
SELECT zpu."Borough", SUM(gtd."total_amount") AS sum_total_amount
FROM public.green_taxi_data gtd
LEFT JOIN public.zones zpu ON gtd."PULocationID"=zpu."LocationID"
WHERE date(gtd."lpep_pickup_datetime") = '2019-09-18'
AND zpu."Borough" != 'Unknown'
GROUP BY zpu."Borough"
HAVING SUM(gtd."total_amount") > 50000
ORDER BY sum_total_amount
```

6. SQL Code:
```
WITH zone_dropoff_and_tip AS (
	SELECT zdo."Zone" AS zone_dropoff,
	gtd.tip_amount
	FROM public.green_taxi_data gtd
	LEFT JOIN public.zones zpu ON gtd."PULocationID"=zpu."LocationID"
	LEFT JOIN public.zones zdo ON gtd."DOLocationID"=zdo."LocationID"
	WHERE date(gtd."lpep_pickup_datetime") >= '2019-09-01'
	AND date(gtd."lpep_pickup_datetime") <= '2019-09-30'
	AND zpu."Zone" = 'Astoria'
)
SELECT zone_dropoff
FROM zone_dropoff_and_tip
WHERE tip_amount = (
	SELECT MAX(tip_amount)
	FROM zone_dropoff_and_tip
	)
```

7. `terraform apply` Output:
```
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # google_bigquery_dataset.week_1_hw_dataset will be created
  + resource "google_bigquery_dataset" "week_1_hw_dataset" {
      + creation_time              = (known after apply)
      + dataset_id                 = "week_1_hw_dataset"
      + default_collation          = (known after apply)
      + delete_contents_on_destroy = false
      + effective_labels           = (known after apply)
      + etag                       = (known after apply)
      + id                         = (known after apply)
      + is_case_insensitive        = (known after apply)
      + last_modified_time         = (known after apply)
      + location                   = "ASIA-SOUTHEAST2"
      + max_time_travel_hours      = (known after apply)
      + project                    = "hardy-portal-411910"
      + self_link                  = (known after apply)
      + storage_billing_model      = (known after apply)
      + terraform_labels           = (known after apply)
    }

  # google_storage_bucket.week-1-hw-bucket will be created
  + resource "google_storage_bucket" "week-1-hw-bucket" {
      + effective_labels            = (known after apply)
      + force_destroy               = true
      + id                          = (known after apply)
      + location                    = "ASIA-SOUTHEAST2"
      + name                        = "week-1-hw-bucket"
      + project                     = (known after apply)
      + public_access_prevention    = (known after apply)
      + self_link                   = (known after apply)
      + storage_class               = "STANDARD"
      + terraform_labels            = (known after apply)
      + uniform_bucket_level_access = (known after apply)
      + url                         = (known after apply)

      + lifecycle_rule {
          + action {
              + type = "AbortIncompleteMultipartUpload"
            }
          + condition {
              + age                   = 1
              + matches_prefix        = []
              + matches_storage_class = []
              + matches_suffix        = []
              + with_state            = (known after apply)
            }
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

google_bigquery_dataset.week_1_hw_dataset: Creating...
google_storage_bucket.week-1-hw-bucket: Creating...
google_storage_bucket.week-1-hw-bucket: Creation complete after 2s [id=week-1-hw-bucket]
google_bigquery_dataset.week_1_hw_dataset: Creation complete after 2s [id=projects/hardy-portal-411910/datasets/week_1_hw_dataset]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```
