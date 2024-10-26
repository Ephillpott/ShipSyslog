#!/bin/bash

# Get the hostname of the machine
HOSTNAME=$(hostname)

# Get the current timestamp in YYYY-MM-DD_HH-MM-SS format
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%SS)

# Define the log file path
LOG_FILE="/var/log/rsyslog" 

# Filter the log file for entries from the last 24 hours
FILTERED_LOG_FILE="/tmp/syslog_last_24h.log"
awk '$3 >= from && $3 <= to' from="$(date +%b" "%d" "%H:%M:%S -d "yesterday")" to="$(date +%b" "%d" "%H:%M:%S)" $LOG_FILE > $FILTERED_LOG_FILE

# Define the S3 bucket name
S3_BUCKET="your-s3-bucket-name"

# Construct the log file name with hostname and timestamp
LOG_FILE_NAME="${HOSTNAME}_${TIMESTAMP}.log.gz"

# Compress the filtered log file
gzip $FILTERED_LOG_FILE

# Copy the compressed, filtered log file to the S3 bucket
aws s3 cp $FILTERED_LOG_FILE.gz s3://$S3_BUCKET/$LOG_FILE_NAME

# Remove the temporary filtered log file
rm $FILTERED_LOG_FILE.gz