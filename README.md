<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a id="readme-top"></a>

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![Unlicense License][license-shield]][license-url]

<br />

<!-- PROJECT LOGO -->
<div align="center">
  <a href="https://github.com/telekom-mms/terraform-aws-alb">
    <img src="logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">AWS Application Load Balancer Module</h3>

  <p align="center">
    PSA-compliant AWS ALB with HTTPS enforcement, access logging, and WAF integration
    <br />
    <a href="https://github.com/telekom-mms/terraform-aws-alb"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/telekom-mms/terraform-aws-alb">View Demo</a>
    ·
    <a href="https://github.com/telekom-mms/terraform-aws-alb/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    ·
    <a href="https://github.com/telekom-mms/terraform-aws-alb/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#features">Features</a></li>
        <li><a href="#opentofu-compatibility">OpenTofu Compatibility</a></li>
        <li><a href="#psa-compliance">PSA Compliance</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#environment-files">Environment Files</a></li>
    <li><a href="#examples">Examples</a></li>
    <li><a href="#security-features">Security Features</a></li>
    <li><a href="#target-group-support">Target Group Support</a></li>
    <li><a href="#outputs">Outputs</a></li>
    <li><a href="#psa-compliance-features">PSA Compliance Features</a></li>
    <li><a href="#integration">Integration</a></li>
    <li><a href="#troubleshooting">Troubleshooting</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

This Terraform module creates PSA-compliant AWS Application Load Balancers with HTTPS enforcement, access logging, and WAF integration.

### Features

- HTTPS-first configuration with SSL/TLS termination (TLS 1.3 by default)
- Automatic HTTP to HTTPS redirection
- Strictest HTTP desync mitigation mode enabled by default
- S3 access logs with KMS encryption support
- WAF Web ACL association support
- Multiple target groups with custom routing rules
- Health checks with configurable parameters
- PSA-compliant security settings
- Invalid header field dropping enabled by default

### OpenTofu Compatibility

This module is designed to work with both Terraform and OpenTofu. The module uses standard HCL syntax that is compatible with both tools, ensuring seamless integration regardless of which infrastructure-as-code tool you choose.

### PSA Compliance

PSA compliance is an internal best practice that is automatically enforced by this module. All resources created by this module automatically adhere to PSA compliance standards without requiring any additional configuration.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple example steps.

### Prerequisites

- Terraform v1.3 or higher
- AWS CLI configured with appropriate permissions

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/telekom-mms/terraform-aws-alb.git
   ```
2. Navigate to the module directory
   ```sh
   cd terraform-aws-alb
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- USAGE -->
## Usage

This module can be used with or without environment files. Below are examples of both approaches.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ENVIRONMENT FILES -->
## Environment Files

The module supports environment-specific configuration through external environment files. This allows you to manage different configurations for various environments (e.g., development, testing, production) without hardcoding values in your Terraform configuration.

### Environment File System

1. **Template File**: A template file `env-template.tfvars` is provided in the `env/` directory. This file contains all configurable variables with their default values.

2. **Creating Environment Files**: To create a specific environment configuration:
   - Copy `env-template.tfvars` to `env/env-<environment>.tfvars` (e.g., `env/env-prod.tfvars`)
   - Modify the copied file with environment-specific values

3. **Using Environment Files**: Specify the environment file to use via the -var-file parameter.

```hcl
module "aws-alb" {
  source = "./terraform-aws-alb"

  # Required variables
  vpc_id = "vpc-123456"
  subnet_ids = ["subnet-123", "subnet-456"]
  security_group_ids = ["sg-789"]
  certificate_arn = "arn:aws:acm:region:account:certificate/cert-id" # REPLACE WITH YOUR ACTUAL CERTIFICATE ARN

  # Other variables
  project_name = "myapp"
  environment = "production"
  name_prefix = "prod-myapp"
  tags = {
    "Environment" = "production"
    "Team" = "operations"
  }

  # Target configuration
  target_port = 8080
  target_protocol = "HTTP"
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- EXAMPLES -->
## Examples

### Basic Usage

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

```hcl
module "aws-alb" {
  source = "./terraform-aws-alb"

  # Basic configuration
  name_prefix = "myapp"
  vpc_id      = "vpc-123456"
  subnet_ids  = ["subnet-123", "subnet-456"]
  
  # Security configuration
  security_group_ids = ["sg-789"]
  certificate_arn    = "arn:aws:acm:region:account:certificate/cert-id"
  
  # Multiple target groups
  target_groups = {
    api = {
      port     = 8080
      protocol = "HTTP"
      health_check = {
        path                = "/health"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout            = 5
        interval           = 30
      }
    }
    web = {
      port     = 3000
      protocol = "HTTP"
      health_check = {
        path = "/ping"
      }
    }
  }

  # Routing rules
  listener_rules = {
    api = {
      priority = 100
      conditions = {
        path_patterns = ["/api/*"]
      }
      target_group_key = "api"
    }
    web = {
      priority = 200
      conditions = {
        path_patterns = ["/*"]
      }
      target_group_key = "web"
    }
  }

  tags = {
    "Environment" = "production"
    "Service"     = "multi-app"
  }
}
```

## Outputs

| Name | Description |
|------|-------------|
| `alb_arn` | ARN of the Application Load Balancer |
| `alb_dns_name` | DNS name of the ALB |
| `alb_zone_id` | Hosted zone ID of the ALB |
| `alb_id` | ID of the ALB |
| `default_target_group_arn` | ARN of the default target group |
| `https_listener_arn` | ARN of the HTTPS listener |
| `http_listener_arn` | ARN of the HTTP listener (if enabled) |
| `target_group_arns` | Map of target group ARNs by key |
| `listener_rule_arns` | Map of listener rule ARNs by key |

## PSA Compliance Features

This module implements the following PSA compliance features (referencing `08-Strukturierte_PSA_Anforderungen_Webserver_LLM.pdf`):

### Security Controls

- **Req 11/15 (Strong Ciphers)**: Enforced via modern TLS 1.3/1.2 policies (`ELBSecurityPolicy-TLS13-1-2-2021-06`).
- **Req 19 (Strict Inspection)**: Enabled via `drop_invalid_header_fields = true` and `desync_mitigation_mode = strictest`.
- **Req 21 (HTTPS Default)**: Mandatory HTTPS listener with automatic HTTP redirection for all port 80 traffic.
- **Req 8 (Secure Logging)**: S3 access logs enabled by default with versioning, encryption (KMS supported), and restricted public access.
- **WAF integration** with fail-closed configuration for layer 7 protection.
- **Deletion protection** enabled by default to prevent accidental resource removal.

### Monitoring & Logging

- CloudWatch metrics integration for ALB and Target Groups.
- Access log retention policies via S3 lifecycle (if configured in bucket).
- Health check monitoring for all registered targets.

### Network Security

- Subnet isolation support
- Security group management
- IP-based access control
- Custom SSL policy support

## Integration

This module is designed to work seamlessly with other infrastructure components:

### Related Modules

- [terraform-aws-security-groups](../terraform-aws-security-groups) - Security group configurations
- [terraform-aws-iam-roles](../terraform-aws-iam-roles) - IAM role management
- [terraform-aws-waf](../terraform-aws-waf) - WAF ACL configuration
- [terraform-aws-s3](../terraform-aws-s3) - Access log storage

### Integration Example

```hcl
# Security Groups
module "alb_security_groups" {
  source = "../terraform-aws-security-groups"
  
  vpc_id = "vpc-123456"
  name   = "alb-security-group"
  
  ingress_rules = [{
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

# S3 Bucket for Access Logs
module "alb_logs" {
  source = "../terraform-aws-s3"
  
  bucket_name = "my-alb-logs"
  versioning  = true
  encryption  = true
}

# ALB Module
module "alb" {
  source = "./terraform-aws-alb"
  
  security_group_ids = [module.alb_security_groups.security_group_id]
  access_logs = {
    bucket = module.alb_logs.bucket_id
    prefix = "alb-logs/"
  }
  # ... other configuration
}
```

## Troubleshooting

Common issues and their solutions:

### Health Check Failures

- Verify target group health check settings
- Ensure backend services are responding on the configured path
- Check security group rules allow health check traffic

### Certificate Issues

- Validate ACM certificate is in the same region as ALB
- Ensure certificate is fully validated
- Check domain names match certificate SAN

### Performance Optimization

- Enable cross-zone load balancing for better distribution
- Configure appropriate target group deregistration delay
- Monitor and adjust scaling policies based on CloudWatch metrics

[Back to top](#readme-top)

## Required Variables

The following variables are required:

```hcl
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

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- SECURITY FEATURES -->
## Security Features

- **TLS 1.3 Enforcement**: Uses `ELBSecurityPolicy-TLS13-1-2-2021-06` by default for strong cipher suites and modern protocol support.
- **Desync Mitigation**: Set to `strictest` mode to prevent HTTP desync attacks.
- **HTTPS Redirect**: Automatic 301 redirection from port 80 to 443.
- **Access Logging**: Enabled by default with secure S3 storage.
- **KMS Encryption**: Support for customer-managed KMS keys for access log encryption.
- **WAF Integration**: Fail-closed configuration to ensure security even if WAF is unavailable.
- **Header Security**: Invalid header fields are automatically dropped.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- TARGET GROUP SUPPORT -->
## Target Group Support

- Default target group for primary application
- Additional target groups with custom routing
- Host header and path pattern routing
- Configurable health checks per target group

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->
## License

Distributed under the Mozilla Public License Version 2.0. See `LICENSE` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->
## Contact

Project Link: [https://github.com/telekom-mms/terraform-aws-alb](https://github.com/telekom-mms/terraform-aws-alb)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/telekom-mms/terraform-aws-alb.svg?style=for-the-badge
[contributors-url]: https://github.com/telekom-mms/terraform-aws-alb/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/telekom-mms/terraform-aws-alb.svg?style=for-the-badge
[forks-url]: https://github.com/telekom-mms/terraform-aws-alb/network/members
[stars-shield]: https://img.shields.io/github/stars/telekom-mms/terraform-aws-alb.svg?style=for-the-badge
[stars-url]: https://github.com/telekom-mms/terraform-aws-alb/stargazers
[issues-shield]: https://img.shields.io/github/issues/telekom-mms/terraform-aws-alb.svg?style=for-the-badge
[issues-url]: https://github.com/telekom-mms/terraform-aws-alb/issues
[license-shield]: https://img.shields.io/github/license/telekom-mms/terraform-aws-alb.svg?style=for-the-badge
[license-url]: https://github.com/telekom-mms/terraform-aws-alb/blob/master/LICENSE.txt
