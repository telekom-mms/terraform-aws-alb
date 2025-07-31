// examples/alb-basic/variables.tf

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "example"
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS listener"
  type        = string
  # You need to provide a valid certificate ARN
  default     = "arn:aws:acm:eu-central-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
}

variable "internal" {
  description = "Whether the ALB is internal"
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "enable_cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing"
  type        = bool
  default     = true
}

variable "enable_http2" {
  description = "Enable HTTP/2"
  type        = bool
  default     = true
}

variable "ssl_policy" {
  description = "SSL policy for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "create_http_listener" {
  description = "Create HTTP listener"
  type        = bool
  default     = true
}

variable "target_port" {
  description = "Target port"
  type        = number
  default     = 80
}

variable "target_protocol" {
  description = "Target protocol"
  type        = string
  default     = "HTTP"
}

variable "health_check_healthy_threshold" {
  description = "Health check healthy threshold"
  type        = number
  default     = 3
}

variable "health_check_interval" {
  description = "Health check interval"
  type        = number
  default     = 30
}

variable "health_check_matcher" {
  description = "Health check matcher"
  type        = string
  default     = "200"
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/"
}

variable "health_check_timeout" {
  description = "Health check timeout"
  type        = number
  default     = 5
}

variable "health_check_unhealthy_threshold" {
  description = "Health check unhealthy threshold"
  type        = number
  default     = 2
}

variable "enable_access_logs" {
  description = "Enable access logs"
  type        = bool
  default     = false
}

variable "create_logs_bucket" {
  description = "Create logs bucket"
  type        = bool
  default     = false
}

variable "access_logs_prefix" {
  description = "Access logs prefix"
  type        = string
  default     = "alb-access-logs"
}

variable "additional_target_groups" {
  description = "Additional target groups"
  type = map(object({
    port                              = number
    protocol                          = string
    priority                          = number
    host_header                       = optional(string)
    path_pattern                      = optional(string)
    health_check_healthy_threshold    = optional(number)
    health_check_interval             = optional(number)
    health_check_matcher              = optional(string)
    health_check_path                 = optional(string)
    health_check_timeout              = optional(number)
    health_check_unhealthy_threshold  = optional(number)
    deregistration_delay              = optional(number)
  }))
  default = {
    api = {
      port         = 8080
      protocol     = "HTTP"
      priority     = 100
      path_pattern = "/api/*"
    }
  }
}

variable "waf_web_acl_arn" {
  description = "WAF Web ACL ARN"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
  default     = {
    Environment = "dev"
    Owner       = "terraform"
    Project     = "alb-example"
  }
}
