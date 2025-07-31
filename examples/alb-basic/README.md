# AWS ALB Basic Example

This example demonstrates how to use the AWS ALB module to create an Application Load Balancer with HTTPS termination and health checks.

## Features

- Application Load Balancer with HTTPS listener
- Optional HTTP listener with redirect to HTTPS
- Health checks for target groups
- Optional access logging to S3
- Additional target groups with path-based routing
- WAF integration support

## Usage

1. Copy this example to your project
2. Update `variables.tf` with your specific values, especially:
   - `certificate_arn`: Your SSL certificate ARN
   - `ec2_instance_ids`: Your EC2 instance IDs (if monitoring EC2)
   - `sns_email_endpoints`: Your notification email addresses

3. Initialize and apply:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Variables

See `variables.tf` for all configurable options.

## Outputs

- `alb_dns_name`: DNS name of the load balancer
- `alb_arn`: ARN of the load balancer
- `target_group_arns`: ARNs of the target groups

## Requirements

- AWS CLI configured
- Terraform >= 1.0
- SSL certificate in AWS Certificate Manager
