# AWS Application Load Balancer Module

## Overview
This module creates PSA-compliant AWS Application Load Balancers with HTTPS enforcement, access logging, and WAF integration.

## Features
- HTTPS-first configuration with SSL/TLS termination
- Automatic HTTP to HTTPS redirection
- S3 access logs with encryption
- WAF Web ACL association support
- Multiple target groups with custom routing rules
- Health checks with configurable parameters
- PSA-compliant security settings

## Usage
```hcl
module "aws-alb" {
  source = "./terraform-aws-alb"

  name_prefix = "myapp"
  vpc_id = "vpc-123456"
  subnet_ids = ["subnet-123", "subnet-456"]
  security_group_ids = ["sg-789"]
  certificate_arn = "arn:aws:acm:region:account:certificate/cert-id"
  
  # Target configuration
  target_port = 8080
  target_protocol = "HTTP"
  
  tags = {
    "Environment" = "production"
  }
}
```

## Security Features
- HTTPS enforcement with modern SSL policies
- HTTP redirects to HTTPS (301 permanent)
- WAF fail-closed configuration
- Invalid header fields are dropped
- S3 access logs with server-side encryption
- Public access blocked on log buckets

## Target Group Support
- Default target group for primary application
- Additional target groups with custom routing
- Host header and path pattern routing
- Configurable health checks per target group

## PSA Compliance
- HTTPS-only traffic enforcement
- Encrypted access logging
- WAF integration ready
- Security headers enforced
- No public S3 bucket access