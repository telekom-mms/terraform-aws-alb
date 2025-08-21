# Environment configuration template for terraform-aws-alb module
# Copy this file to env-<environment>.tfvars and modify as needed

# Project and environment settings
project_name = ""  # Name of the project
environment = ""  # Environment (e.g., prod, dev, test)
name_prefix = ""  # Prefix for resource names (if not provided, will use project-environment pattern)
tags = {}  # Additional tags for all resources

# Network configuration
vpc_id = ""  # VPC ID where the ALB will be created
subnet_ids = []  # List of subnet IDs for the ALB
security_group_ids = []  # List of security group IDs for the ALB

# SSL/TLS configuration
certificate_arn = ""  # ARN of the SSL certificate for HTTPS listener
internal = false  # Whether the ALB is internal (true) or internet-facing (false)
enable_deletion_protection = true  # Enable deletion protection for the ALB
enable_cross_zone_load_balancing = true  # Enable cross-zone load balancing
enable_http2 = true  # Enable HTTP/2 support
ssl_policy = "ELBSecurityPolicy-TLS-1-2-2017-01"  # SSL policy for HTTPS listener
create_http_listener = true  # Create HTTP listener that redirects to HTTPS

# Target group configuration
target_port = 80  # Port for the default target group
target_protocol = "HTTP"  # Protocol for the default target group
health_check_healthy_threshold = 3  # Number of consecutive health check successes required before considering a target healthy
health_check_interval = 30  # Approximate amount of time, in seconds, between health checks
health_check_matcher = "200"  # Response codes to use when checking for a healthy responses from a target
health_check_path = "/"  # Destination for health checks
health_check_timeout = 5  # Amount of time, in seconds, during which no response from a target means a failed health check
health_check_unhealthy_threshold = 2  # Number of consecutive health check failures required before considering a target unhealthy
deregistration_delay = 300  # Amount of time, in seconds, for targets to drain connections during deregistration

# Additional target groups
additional_target_groups = {}  # Additional target groups to create

# WAF configuration
waf_web_acl_arn = ""  # ARN of the WAF Web ACL to associate with the ALB

# Access logs configuration
enable_access_logs = false  # Enable access logs for the ALB
create_logs_bucket = false  # Create S3 bucket for ALB access logs
access_logs_bucket = ""  # S3 bucket name for ALB access logs (required if enable_access_logs=true and create_logs_bucket=false)
access_logs_prefix = "alb-access-logs"  # S3 prefix for ALB access logs

# Additional configuration
env_file = ""  # Path to the environment file to load (e.g., 'env/env-prod.tfvars')
aws_region = ""  # AWS region where resources will be created
s3_server_side_encryption_algorithm = "AES256"  # Server-side encryption algorithm for S3 bucket
alb_logs_s3_policy_principal = ""  # IAM principal for S3 bucket policy (default is ELB service account)
access_logs_enabled = false  # Enable access logs for the ALB
health_check_enabled = true  # Enable health checks for target groups