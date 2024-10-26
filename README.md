# Automated Log Shipping to AWS S3 with Terraform

This project demonstrates how to automate the secure shipping of system logs to an AWS S3 bucket using shell scripts and Terraform. It offers flexible deployment options:

**Run the scripts independently:**

* **`ship_logs.sh`:**  This script collects system logs, filters them for the last 24 hours, compresses them, and securely uploads them to an S3 bucket.
* **`setup_cron.sh`:** This script sets up a cron job to automate the execution of `ship_logs.sh`.

**Or, use Terraform for complete automation:**

* **`main.tf`:**  This Terraform configuration file automates the entire process, including:
    * Provisioning an EC2 instance.
    * Creating the `ship_logs.sh` script on the instance.
    * Setting up a cron job to run the script automatically.

This flexibility allows you to choose the deployment method that best suits your needs and infrastructure.

## Features

* **Automated Log Collection:**  Efficiently collects and ships system logs to an S3 bucket.
* **Log Filtering:** Includes only log entries from the last 24 hours to reduce storage costs and focus on recent events.
* **Compression:** Compresses log files to minimize storage space and bandwidth usage.
* **Dynamic File Naming:** Log files are dynamically named with the hostname and timestamp for easy identification and organization.
* **Secure Upload:** Leverages the AWS CLI for secure transfer of logs to S3.
* **Terraform Automation:**  Provides infrastructure-as-code for easy deployment and management.

## How it Works

**Independent Scripts:**

1. **`ship_logs.sh`:**
   - Gathers the hostname and current timestamp.
   - Filters the system log file (`/var/log/syslog`) for the last 24 hours.
   - Compresses the filtered log file.
   - Uploads the compressed log file to the specified S3 bucket.
   - Removes the temporary filtered log file.

2. **`setup_cron.sh`:**
   - Defines the cron job schedule.
   - Adds the cron job to execute `ship_logs.sh` automatically.

**Terraform Automation:**

1. **`main.tf`:**
   - Provisions an EC2 instance.
   - Creates `ship_logs.sh` on the instance.
   - Sets up a cron job to run `ship_logs.sh` at the defined schedule.

## Prerequisites

* **AWS Account:** An active AWS account with necessary permissions to create EC2 instances and S3 buckets.
* **Terraform:** Terraform CLI installed and configured.
* **AWS CLI:** AWS CLI installed and configured with appropriate credentials.
* **SSH Key Pair:** An SSH key pair for secure access to the EC2 instance.

## Usage

**Independent Scripts:**

1. **Configure `ship_logs.sh`:** Update the script with your S3 bucket name and other relevant settings.
2. **Run `ship_logs.sh`:** Execute the script manually or using a scheduler.
3. **Run `setup_cron.sh`:**  Execute the script to set up the cron job for automated log shipping.

**Terraform Automation:**

1. **Configure `main.tf`:**  Update the file with your AWS credentials, S3 bucket name, SSH key path, and other settings.
2. **Initialize Terraform:** `terraform init`
3. **Apply the configuration:** `terraform apply`

## Security Considerations

* **IAM Roles:**  Consider using IAM roles for EC2 instances to grant the necessary permissions to access S3, instead of hardcoding AWS credentials in the script.
* **S3 Bucket Policies:** Implement appropriate S3 bucket policies to restrict access and ensure data security.
* **Network Security:** Configure security groups to control inbound and outbound traffic to your EC2 instance.
* **Log File Sensitivity:** If you are dealing with highly sensitive logs, consider implementing additional security measures such as encryption at rest and in transit.
