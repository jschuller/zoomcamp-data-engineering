# COMMAND FOR DOWNLOADING INTO LOCAL
# wget -i raw_data_urls.txt -P data/ -w 2


# COMMAND FOR DOWNLOADING AND MOVE INTO GCS FOLDER
#!/bin/bash

# Read each URL from raw_data_urls.txt
while IFS= read -r url; do
    # Extract the filename from the URL
    filename=$(basename "$url")
    
    # Use wget to download the file
    wget "$url" -O "$filename"
    
    # Use gsutil to copy the downloaded file to Google Cloud Storage
    gsutil cp "$filename" gs://week-4-hw-bucket-docksgit/tripdata/
    
    # Remove the downloaded file after uploading
    rm "$filename"
done < raw_data_urls.txt
