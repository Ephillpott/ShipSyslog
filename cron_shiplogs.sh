#!/bin/bash

# Define the path to log shipping script
LOG_SHIPPING_SCRIPT="/path/to/shiplogs.sh"

# Define the cron job schedule (Daily at 2:00 AM here)
CRON_SCHEDULE="0 2 * * *"

# Add the cron job 
(crontab -l 2>/dev/null; echo "$CRON_SCHEDULE $LOG_SHIPPING_SCRIPT") | crontab -
