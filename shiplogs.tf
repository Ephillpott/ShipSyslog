resource "aws_instance" "example" {
  ami                    = "ami-0c94855ba95c574c9" # Replace with your AMI ID
  instance_type          = "t2.micro"
  # ... other instance configurations ...
}

# Define the script content
resource "null_resource" "ship_logs_script" {
  provisioner "local-exec" {
    connection {
      type = "ssh"
      user = "ubuntu" # Replace with your instance user
      private_key = file("~/.ssh/id_rsa") # Replace with your private key path
      host = aws_instance.example.public_ip
    }

    command = <<EOF
      cat > /tmp/ship_logs.sh <<EOL
#!/bin/bash


HOSTNAME=$(hostname)
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%SS)
LOG_FILE="/var/log/rsyslog" 
FILTERED_LOG_FILE="/tmp/syslog_last_24h.log"
awk '$3 >= from && $3 <= to' from="$(date +%b" "%d" "%H:%M:%S -d "yesterday")" to="$(date +%b" "%d" "%H:%M:%S)" $LOG_FILE > $FILTERED_LOG_FILE

# Define the S3 bucket name
S3_BUCKET="your-s3-bucket-name"


LOG_FILE_NAME="${HOSTNAME}_${TIMESTAMP}.log.gz"
gzip $FILTERED_LOG_FILE
aws s3 cp $FILTERED_LOG_FILE.gz s3://$S3_BUCKET/$LOG_FILE_NAME
rm $FILTERED_LOG_FILE.gz

EOL
      chmod +x /tmp/ship_logs.sh
    EOF
  }

  depends_on = [aws_instance.example]
}

# Set up cron job to run script every 24hrs at 0200
resource "null_resource" "cron_job" {
  provisioner "local-exec" {
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host = aws_instance.example.public_ip
    }

    command = <<EOF
      echo "0 2 * * * /tmp/ship_logs.sh" | crontab -
    EOF
  }

  depends_on = [aws_instance.example, null_resource.ship_logs_script]
}
