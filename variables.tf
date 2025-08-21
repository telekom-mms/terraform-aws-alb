// variables.tf


variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "demo-app"
}

variable "environment" {
  description = "Environment (e.g., prod, dev, test)"
  type        = string
  default     = "test"
}

variable "name_prefix" {
  description = "Prefix for resource names (if not provided, will use project-environment pattern)"
  type        = string
  default     = ""
}


variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID where the ALB will be created"
  type        = string
  default     = "vpc-12345678" # Demo VPC ID
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
  default     = ["subnet-12345678", "subnet-87654321"] # Demo subnet IDs
}

variable "security_group_ids" {
  description = "List of security group IDs for the ALB"
  type        = list(string)
  default     = ["sg-12345678"] # Demo security group ID
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS listener"
  type        = string
  default     = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012" # Demo certificate ARN
}

variable "internal" {
  description = "Whether the ALB is internal (true) or internet-facing (false)"
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the ALB"
  type        = bool
  default     = true
}

variable "enable_cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing"
  type        = bool
  default     = true
}

variable "enable_http2" {
  description = "Enable HTTP/2 support"
  type        = bool
  default     = true
}

variable "ssl_policy" {
  description = "SSL policy for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "create_http_listener" {
  description = "Create HTTP listener that redirects to HTTPS"
  type        = bool
  default     = true
}

variable "target_port" {
  description = "Port for the default target group"
  type        = number
  default     = 80
}

variable "target_protocol" {
  description = "Protocol for the default target group"
  type        = string
  default     = "HTTP"
}

variable "health_check_healthy_threshold" {
  description = "Number of consecutive health check successes required before considering a target healthy"
  type        = number
  default     = 3
}

variable "health_check_interval" {
  description = "Approximate amount of time, in seconds, between health checks"
  type        = number
  default     = 30
}

variable "health_check_matcher" {
  description = "Response codes to use when checking for a healthy responses from a target"
  type        = string
  default     = "200"
}

variable "health_check_path" {
  description = "Destination for health checks"
  type        = string
  default     = "/"
}

variable "health_check_timeout" {
  description = "Amount of time, in seconds, during which no response from a target means a failed health check"
  type        = number
  default     = 5
}

variable "health_check_unhealthy_threshold" {
  description = "Number of consecutive health check failures required before considering a target unhealthy"
  type        = number
  default     = 2
}

variable "deregistration_delay" {
  description = "Amount of time, in seconds, for targets to drain connections during deregistration"
  type        = number
  default     = 300
}

variable "additional_target_groups" {
  description = "Additional target groups to create"
  type = map(object({
    port                             = number
    protocol                         = string
    priority                         = number
    host_header                      = optional(string)
    path_pattern                     = optional(string)
    health_check_healthy_threshold   = optional(number)
    health_check_interval            = optional(number)
    health_check_matcher             = optional(string)
    health_check_path                = optional(string)
    health_check_timeout             = optional(number)
    health_check_unhealthy_threshold = optional(number)
    deregistration_delay             = optional(number)
  }))
  default = {}
}

variable "waf_web_acl_arn" {
  description = "ARN of the WAF Web ACL to associate with the ALB"
  type        = string
  default     = ""
}

variable "enable_access_logs" {
  description = "Enable access logs for the ALB"
  type        = bool
  default     = false
}

variable "create_logs_bucket" {
  description = "Create S3 bucket for ALB access logs"
  type        = bool
  default     = false
}

variable "access_logs_bucket" {
  description = "S3 bucket name for ALB access logs (required if enable_access_logs=true and create_logs_bucket=false)"
  type        = string
  default     = ""
}

variable "access_logs_prefix" {
  description = "S3 prefix for ALB access logs"
  type        = string
  default     = "alb-access-logs"
}

variable "env_file" {
  description = "Path to the environment file to load (e.g., 'env/env-prod.tfvars'). If not provided, no environment file will be loaded."
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "s3_server_side_encryption_algorithm" {
  description = "Server-side encryption algorithm for S3 bucket"
  type        = string
  default     = "AES256"
}

variable "alb_logs_s3_policy_principal" {
  description = "IAM principal for S3 bucket policy (default is ELB service account)"
  type        = string
  default     = ""
}


variable "access_logs_enabled" {
  description = "Enable access logs for the ALB"
  type        = bool
  default     = true
}

variable "health_check_enabled" {
  description = "Enable health checks for target groups"
  type        = bool
  default     = true
}