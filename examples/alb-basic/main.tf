// examples/alb-basic/main.tf

provider "aws" {
  region = "eu-central-1"
}

# Data sources for existing resources
data "aws_vpc" "existing" {
  default = true
}

data "aws_subnets" "existing" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}

data "aws_security_groups" "existing" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}

# ALB Module
module "alb" {
  source = "registry.terraform.io/telekom-mms/alb/aws"

  tpl_name            = "albmms"
  tpl_local_name      = "alb"
  vpc_id              = data.aws_vpc.existing.id
  subnet_ids          = data.aws_subnets.existing.ids
  security_group_ids  = data.aws_security_groups.existing.ids
  certificate_arn     = var.certificate_arn
  
  # ALB Configuration
  internal                          = var.internal
  enable_deletion_protection        = var.enable_deletion_protection
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_http2                     = var.enable_http2
  ssl_policy                       = var.ssl_policy
  create_http_listener             = var.create_http_listener
  
  # Target Group Configuration
  target_port     = var.target_port
  target_protocol = var.target_protocol
  
  # Health Check Configuration
  health_check_healthy_threshold   = var.health_check_healthy_threshold
  health_check_interval           = var.health_check_interval
  health_check_matcher            = var.health_check_matcher
  health_check_path               = var.health_check_path
  health_check_timeout            = var.health_check_timeout
  health_check_unhealthy_threshold = var.health_check_unhealthy_threshold
  
  # Access Logs
  enable_access_logs   = var.enable_access_logs
  create_logs_bucket   = var.create_logs_bucket
  access_logs_prefix   = var.access_logs_prefix
  
  # Additional Target Groups
  additional_target_groups = var.additional_target_groups
  
  # WAF Integration
  waf_web_acl_arn = var.waf_web_acl_arn
  
  tags = var.tags
}