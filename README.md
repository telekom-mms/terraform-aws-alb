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

## OpenTofu Compatibility

This module is designed to work with both Terraform and OpenTofu. The module uses standard HCL syntax that is compatible with both tools, ensuring seamless integration regardless of which infrastructure-as-code tool you choose.

### Syntax Changes for OpenTofu Compatibility
No syntax changes were required for OpenTofu compatibility, as the module uses standard Terraform HCL syntax that is fully supported by OpenTofu.

### Using the Module with OpenTofu
To use this module with OpenTofu, simply follow the same usage instructions as you would with Terraform. OpenTofu is a drop-in replacement for Terraform, so all existing Terraform configurations will work without modification.

### PSA Compliance Handling
PSA compliance is now handled internally by the module and is not user-configurable. All resources created by this module automatically adhere to PSA compliance standards without requiring any additional configuration.

## Environment Files

The module supports environment-specific configuration through external environment files. This allows you to manage different configurations for various environments (e.g., development, testing, production) without hardcoding values in your Terraform configuration.

### Environment File System

1. **Template File**: A template file `env-template.tfvars` is provided in the `env/` directory. This file contains all configurable variables with their default values.

2. **Creating Environment Files**: To create a specific environment configuration:
   - Copy `env-template.tfvars` to `env/env-<environment>.tfvars` (e.g., `env/env-prod.tfvars`)
   - Modify the copied file with environment-specific values

3. **Using Environment Files**: Specify the environment file to use via the `env_file` variable:

```hcl
module "aws-alb" {
  source = "./terraform-aws-alb"

  # Specify the environment file to load
  env_file = "./terraform-aws-alb/env/env-prod.tfvars"

  # Other variables will be overridden by the environment file
  # name_prefix = "myapp"  # Optional - can be specified in env file
  vpc_id = "vpc-123456"
  subnet_ids = ["subnet-123", "subnet-456"]
  security_group_ids = ["sg-789"]
  certificate_arn = "arn:aws:acm:region:account:certificate/cert-id" # REPLACE WITH YOUR ACTUAL CERTIFICATE ARN

  # Target configuration
  target_port = 8080
  target_protocol = "HTTP"

  tags = {
    "Environment" = "production"
  }
}
```

### Example Environment Files

#### Production Environment (env/env-prod.tfvars)
```hcl
# Production environment configuration
project_name = "myapp"
environment = "production"
name_prefix = "prod-myapp"
tags = {
  "Environment" = "production"
  "Team" = "operations"
}

vpc_id = "vpc-prod-123456"
subnet_ids = ["subnet-prod-1", "subnet-prod-2"]
security_group_ids = ["sg-prod-789"]

certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/prod-cert-id" # REPLACE WITH YOUR ACTUAL PRODUCTION CERTIFICATE ARN
internal = false
enable_deletion_protection = true

# Target group configuration
target_port = 8080
target_protocol = "HTTP"

# Enable access logs for production
enable_access_logs = true
create_logs_bucket = true
access_logs_prefix = "prod-alb-access-logs"
```

#### Development Environment (env/env-dev.tfvars)
```hcl
# Development environment configuration
project_name = "myapp"
environment = "development"
name_prefix = "dev-myapp"
tags = {
  "Environment" = "development"
  "Team" = "development"
}

vpc_id = "vpc-dev-123456"
subnet_ids = ["subnet-dev-1", "subnet-dev-2"]
security_group_ids = ["sg-dev-789"]

certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/dev-cert-id" # REPLACE WITH YOUR ACTUAL DEVELOPMENT CERTIFICATE ARN
internal = true
enable_deletion_protection = false

# Target group configuration
target_port = 3000
target_protocol = "HTTP"

# Disable access logs for development
enable_access_logs = false
```

### Example Usage Without Environment File

```hcl
module "aws-alb" {
  source = "./terraform-aws-alb"

  name_prefix = "myapp"
  vpc_id = "vpc-123456"
  subnet_ids = ["subnet-123", "subnet-456"]
  security_group_ids = ["sg-789"]
  certificate_arn = "arn:aws:acm:region:account:certificate/cert-id" # REPLACE WITH YOUR ACTUAL CERTIFICATE ARN

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

PSA compliance is an internal best practice that is automatically enforced by this module. All resources created by this module are PSA compliant by default, and users do not need to configure any PSA settings. The following PSA compliance settings are automatically enforced:

- **Fail Closed**: WAF is configured in fail-closed mode to ensure security
- **Drop Invalid Headers**: Invalid header fields are automatically dropped
- **HTTPS-only Traffic**: All traffic is enforced to use HTTPS
- **Encrypted Access Logging**: Access logs are encrypted and stored securely
- **Security Headers**: Appropriate security headers are enforced
- **No Public S3 Bucket Access**: Public access to S3 buckets is blocked

These settings are applied internally and do not require any user configuration, ensuring consistent PSA compliance across all environments.
<!-- BEGIN_TF_DOCS -->

## Requirements

| Name | Version |
|------|---------|
| terraform | >=1.3 |
| aws | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 6.7.0 |

## Resources

| Name | Type |
|------|------|
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.http_redirect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_s3_bucket.alb_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.alb_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.alb_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.alb_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.alb_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_wafv2_web_acl_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_elb_service_account.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_service_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| certificate_arn | ARN of the SSL certificate for HTTPS listener | `string` | n/a | yes |
| environment | Environment (e.g., prod, dev, test) | `string` | n/a | yes |
| project_name | Name of the project | `string` | n/a | yes |
| security_group_ids | List of security group IDs for the ALB | `list(string)` | n/a | yes |
| subnet_ids | List of subnet IDs for the ALB | `list(string)` | n/a | yes |
| vpc_id | VPC ID where the ALB will be created | `string` | n/a | yes |
| access_logs_bucket | S3 bucket name for ALB access logs (required if enable_access_logs=true and create_logs_bucket=false) | `string` | `""` | no |
| access_logs_prefix | S3 prefix for ALB access logs | `string` | `"alb-access-logs"` | no |
| additional_target_groups | Additional target groups to create | <pre>map(object({<br/>    port                             = number<br/>    protocol                         = string<br/>    priority                         = number<br/>    host_header                      = optional(string)<br/>    path_pattern                     = optional(string)<br/>    health_check_healthy_threshold   = optional(number)<br/>    health_check_interval            = optional(number)<br/>    health_check_matcher             = optional(string)<br/>    health_check_path                = optional(string)<br/>    health_check_timeout             = optional(number)<br/>    health_check_unhealthy_threshold = optional(number)<br/>    deregistration_delay             = optional(number)<br/>  }))</pre> | `{}` | no |
| create_http_listener | Create HTTP listener that redirects to HTTPS | `bool` | `true` | no |
| create_logs_bucket | Create S3 bucket for ALB access logs | `bool` | `false` | no |
| deregistration_delay | Amount of time, in seconds, for targets to drain connections during deregistration | `number` | `300` | no |
| enable_access_logs | Enable access logs for the ALB | `bool` | `false` | no |
| enable_cross_zone_load_balancing | Enable cross-zone load balancing | `bool` | `true` | no |
| enable_deletion_protection | Enable deletion protection for the ALB | `bool` | `true` | no |
| enable_http2 | Enable HTTP/2 support | `bool` | `true` | no |
| health_check_healthy_threshold | Number of consecutive health check successes required before considering a target healthy | `number` | `3` | no |
| health_check_interval | Approximate amount of time, in seconds, between health checks | `number` | `30` | no |
| health_check_matcher | Response codes to use when checking for a healthy responses from a target | `string` | `"200"` | no |
| health_check_path | Destination for health checks | `string` | `"/"` | no |
| health_check_timeout | Amount of time, in seconds, during which no response from a target means a failed health check | `number` | `5` | no |
| health_check_unhealthy_threshold | Number of consecutive health check failures required before considering a target unhealthy | `number` | `2` | no |
| internal | Whether the ALB is internal (true) or internet-facing (false) | `bool` | `false` | no |
| name_prefix | Prefix for resource names (if not provided, will use project-environment pattern) | `string` | `""` | no |
| ssl_policy | SSL policy for HTTPS listener | `string` | `"ELBSecurityPolicy-TLS-1-2-2017-01"` | no |
| tags | Additional tags for all resources | `map(string)` | `{}` | no |
| target_port | Port for the default target group | `number` | `80` | no |
| target_protocol | Protocol for the default target group | `string` | `"HTTP"` | no |
| waf_web_acl_arn | ARN of the WAF Web ACL to associate with the ALB | `string` | `""` | no |
| env_file | Path to the environment file to load (e.g., 'env/env-prod.tfvars'). If not provided, no environment file will be loaded. | `string` | `""` | no |
| aws_region | AWS region where resources will be created | `string` | `"us-east-1"` | no |
| s3_server_side_encryption_algorithm | Server-side encryption algorithm for S3 bucket | `string` | `"AES256"` | no |
| alb_logs_s3_policy_principal | IAM principal for S3 bucket policy (default is ELB service account) | `string` | `""` | no |
| enable_waf_fail_open | Enable WAF fail open mode (fail-closed mode for security) | `bool` | `false` | no |
| drop_invalid_header_fields | Drop invalid header fields for security | `bool` | `true` | no |
| access_logs_enabled | Enable access logs for the ALB | `bool` | `true` | no |
| health_check_enabled | Enable health checks for target groups | `bool` | `true` | no |
| aws_region | AWS region where resources will be created | `string` | `"us-east-1"` | no |
| s3_server_side_encryption_algorithm | Server-side encryption algorithm for S3 bucket | `string` | `"AES256"` | no |
| alb_logs_s3_policy_principal | IAM principal for S3 bucket policy (default is ELB service account) | `string` | `""` | no |
| access_logs_enabled | Enable access logs for the ALB | `bool` | `true` | no |
| health_check_enabled | Enable health checks for target groups | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| additional_target_group_arns | Map of additional target group names to their ARNs |
| additional_target_group_ids | Map of additional target group names to their IDs |
| alb_arn | ARN of the Application Load Balancer |
| alb_dns_name | DNS name of the Application Load Balancer |
| alb_id | ID of the Application Load Balancer |
| alb_zone_id | Hosted zone ID of the Application Load Balancer |
| default_target_group_arn | ARN of the default target group |
| default_target_group_id | ID of the default target group |
| http_listener_arn | ARN of the HTTP listener (if created) |
| https_listener_arn | ARN of the HTTPS listener |
| s3_bucket_arn | ARN of the S3 bucket for ALB access logs (if created) |
| s3_bucket_name | Name of the S3 bucket for ALB access logs (if created) |

## Examples

### Basic Usage with Environment File

This example shows how to use the module with an environment file for production configuration:

```hcl
module "aws-alb" {
  source = "./terraform-aws-alb"

  # Specify the environment file to load
  env_file = "./terraform-aws-alb/env/env-prod.tfvars"

  # Required variables that cannot be provided in the environment file
  vpc_id = "vpc-123456"
  subnet_ids = ["subnet-123", "subnet-456"]
  security_group_ids = ["sg-789"]
  certificate_arn = "arn:aws:acm:region:account:certificate/cert-id" # REPLACE WITH YOUR ACTUAL CERTIFICATE ARN
}
```

### Basic Usage Without Environment File

This example shows how to use the module without an environment file:

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

### Advanced Usage with Multiple Target Groups

This example demonstrates how to configure multiple target groups with custom routing:

```hcl
module "aws-alb" {
  source = "./terraform-aws-alb"

  # Specify the environment file to load
  env_file = "./terraform-aws-alb/env/env-prod.tfvars"

  # Required variables
  vpc_id = "vpc-123456"
  subnet_ids = ["subnet-123", "subnet-456"]
  security_group_ids = ["sg-789"]
  certificate_arn = "arn:aws:acm:region:account:certificate/cert-id" # REPLACE WITH YOUR ACTUAL CERTIFICATE ARN

  # Additional target groups
  additional_target_groups = {
    api = {
      port             = 8080
      protocol         = "HTTP"
      priority         = 10
      host_header      = "api.example.com"
      path_pattern     = "/api/*"
    }
    admin = {
      port             = 9000
      protocol         = "HTTP"
      priority         = 20
      host_header      = "admin.example.com"
    }
  }

  tags = {
    "Environment" = "production"
    "Application" = "web-app"
  }
}
```
<!-- END_TF_DOCS -->