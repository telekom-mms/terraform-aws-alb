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
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the ALB"
  type        = list(string)
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS listener"
  type        = string
  default     = ""
}

variable "waf_web_acl_arn" {
  description = "ARN of the WAF Web ACL to associate with the ALB"
  type        = string
  default     = ""
}

variable "enable_access_logs" {
  description = "Enable access logs for the ALB"
  type        = bool
  default     = true # Best practice: enable logging by default
}

variable "create_logs_bucket" {
  description = "Create S3 bucket for ALB access logs"
  type        = bool
  default     = true # Secure-by-default: create bucket if logging enabled
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

variable "s3_kms_key_arn" {
  description = "ARN of the KMS key for S3 bucket encryption (if empty, uses S3 managed keys)"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
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

variable "internal" {
  description = "Whether the ALB should be internal"
  type        = bool
  default     = false
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle"
  type        = number
  default     = 60
}

variable "enable_deletion_protection" {
  description = "Whether to enable deletion protection"
  type        = bool
  default     = true
}

variable "enable_cross_zone_load_balancing" {
  description = "Whether to enable cross-zone load balancing"
  type        = bool
  default     = false
}

variable "enable_http2" {
  description = "Whether to enable HTTP/2"
  type        = bool
  default     = true
}

variable "drop_invalid_header_fields" {
  description = "Whether to drop invalid HTTP header fields"
  type        = bool
  default     = true
}

variable "desync_mitigation_mode" {
  description = "Determines how the load balancer mitigates desync attacks"
  type        = string
  default     = "defensive"
}

variable "preserve_host_header" {
  description = "Indicates whether the Host header should be preserved and forwarded to targets"
  type        = bool
  default     = false
}

variable "target_port" {
  description = "The port on which targets receive traffic"
  type        = number
  default     = 80
}

variable "target_protocol" {
  description = "The protocol to use for routing traffic to targets"
  type        = string
  default     = "HTTP"
}

variable "health_check_healthy_threshold" {
  description = "The number of consecutive health check successes required before considering an unhealthy target healthy"
  type        = number
  default     = 3
}

variable "health_check_interval" {
  description = "The approximate amount of time, in seconds, between health checks of an individual target"
  type        = number
  default     = 30
}

variable "health_check_matcher" {
  description = "The HTTP codes to use when checking for a successful response from a target"
  type        = string
  default     = "200"
}

variable "health_check_path" {
  description = "The destination for health checks on the targets"
  type        = string
  default     = "/"
}

variable "health_check_timeout" {
  description = "The amount of time, in seconds, during which no response means a failed health check"
  type        = number
  default     = 5
}

variable "health_check_unhealthy_threshold" {
  description = "The number of consecutive health check failures required before considering a target unhealthy"
  type        = number
  default     = 2
}

variable "deregistration_delay" {
  description = "The amount of time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused"
  type        = number
  default     = 300
}

variable "ssl_policy" {
  description = "The security policy that defines which ciphers and protocols are supported"
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "create_http_listener" {
  description = "Whether to create an HTTP listener that redirects to HTTPS"
  type        = bool
  default     = true
}

variable "additional_target_groups" {
  description = "Additional target groups to create"
  type = map(object({
    port     = number
    protocol = string
    # Health check settings
    health_check_enabled             = optional(bool)
    health_check_healthy_threshold   = optional(number)
    health_check_interval            = optional(number)
    health_check_matcher             = optional(string)
    health_check_path                = optional(string)
    health_check_timeout             = optional(number)
    health_check_unhealthy_threshold = optional(number)
    # Connection draining
    deregistration_delay = optional(number)
    # Routing
    host_header  = optional(string)
    path_pattern = optional(string)
    priority     = number
  }))
  default = {}
}