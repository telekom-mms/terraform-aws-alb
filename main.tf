##Written by Marc Straubinger
// main.tf


// main.tf
# Written by Marc Straubinger - Overhauled for Security-First Best Practices

# S3 Bucket for ALB Access Logs
resource "aws_s3_bucket" "alb_logs" {
  count  = var.enable_access_logs && var.create_logs_bucket ? 1 : 0
  bucket = var.access_logs_bucket != "" ? var.access_logs_bucket : "${local.name_prefix}-logs"

  # PSA Compliance: Req 8 (Logging must be secure)
  force_destroy = false

  tags = merge(local.common_tags, {
    "Name"          = var.access_logs_bucket != "" ? var.access_logs_bucket : "${local.name_prefix}-logs"
    "Purpose"       = "ALB Access Logs"
    "PSA-Compliant" = "true"
  })
}

resource "aws_s3_bucket_versioning" "alb_logs" {
  count  = var.enable_access_logs && var.create_logs_bucket ? 1 : 0
  bucket = aws_s3_bucket.alb_logs[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "alb_logs" {
  count  = var.enable_access_logs && var.create_logs_bucket ? 1 : 0
  bucket = aws_s3_bucket.alb_logs[0].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.s3_kms_key_arn
      sse_algorithm     = var.s3_kms_key_arn != "" ? "aws:kms" : var.s3_server_side_encryption_algorithm
    }
  }
}

resource "aws_s3_bucket_public_access_block" "alb_logs" {
  count  = var.enable_access_logs && var.create_logs_bucket ? 1 : 0
  bucket = aws_s3_bucket.alb_logs[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "alb_logs" {
  count  = var.enable_access_logs && var.create_logs_bucket ? 1 : 0
  bucket = aws_s3_bucket.alb_logs[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowELBLogDelivery"
        Effect = "Allow"
        Principal = {
          AWS = var.alb_logs_s3_policy_principal != "" ? var.alb_logs_s3_policy_principal : "arn:aws:iam::${data.aws_elb_service_account.main.id}:root"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.alb_logs[0].arn}/${local.access_logs_resource_path}"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      },
      {
        Sid    = "AWSLogDeliveryWrite"
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.alb_logs[0].arn}/${local.access_logs_resource_path}"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
            "s3:x-amz-acl"      = "bucket-owner-full-control"
          }
        }
      },
      {
        Sid    = "AWSLogDeliveryAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.alb_logs[0].arn
      }
    ]
  })
}

# Application Load Balancer
resource "aws_lb" "this" {
  name               = "${local.name_prefix}-alb"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  idle_timeout                     = var.idle_timeout
  enable_deletion_protection       = var.enable_deletion_protection
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_http2                     = var.enable_http2

  # PSA Compliance: security-first attributes
  enable_waf_fail_open       = false # Fail closed
  drop_invalid_header_fields = var.drop_invalid_header_fields
  desync_mitigation_mode     = var.desync_mitigation_mode
  preserve_host_header       = var.preserve_host_header

  dynamic "access_logs" {
    for_each = var.enable_access_logs ? [1] : []
    content {
      bucket  = var.create_logs_bucket ? aws_s3_bucket.alb_logs[0].bucket : var.access_logs_bucket
      prefix  = var.access_logs_prefix
      enabled = var.access_logs_enabled
    }
  }

  tags = merge(local.common_tags, {
    "Name"          = "${local.name_prefix}-alb"
    "PSA-Compliant" = "true"
  })
}

# Default Target Group
resource "aws_lb_target_group" "default" {
  name     = "${local.name_prefix}-tg-default"
  port     = var.target_port
  protocol = var.target_protocol
  vpc_id   = var.vpc_id

  health_check {
    enabled             = var.health_check_enabled
    healthy_threshold   = var.health_check_healthy_threshold
    interval            = var.health_check_interval
    matcher             = var.health_check_matcher
    path                = var.health_check_path
    port                = "traffic-port"
    protocol            = var.target_protocol
    timeout             = var.health_check_timeout
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  # Connection draining
  deregistration_delay = var.deregistration_delay

  tags = merge(local.common_tags, {
    "Name"          = "${local.name_prefix}-tg-default"
    "PSA-Compliant" = "true"
  })
}

# HTTPS Listener (Primary)
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }

  tags = merge(local.common_tags, {
    "Name"          = "${local.name_prefix}-listener-https"
    "PSA-Compliant" = "true"
  })
}

# HTTP Listener (Redirect to HTTPS)
# PSA Compliance: Req 21 (HTTPS by default)
resource "aws_lb_listener" "http_redirect" {
  count             = var.create_http_listener ? 1 : 0
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = merge(local.common_tags, {
    "Name"          = "${local.name_prefix}-listener-http-redirect"
    "PSA-Compliant" = "true"
  })
}

# Additional Target Groups
resource "aws_lb_target_group" "additional" {
  for_each = var.additional_target_groups

  name     = "${local.name_prefix}-tg-${each.key}"
  port     = each.value.port
  protocol = each.value.protocol
  vpc_id   = var.vpc_id

  health_check {
    enabled             = lookup(each.value, "health_check_enabled", var.health_check_enabled)
    healthy_threshold   = lookup(each.value, "health_check_healthy_threshold", var.health_check_healthy_threshold)
    interval            = lookup(each.value, "health_check_interval", var.health_check_interval)
    matcher             = lookup(each.value, "health_check_matcher", var.health_check_matcher)
    path                = lookup(each.value, "health_check_path", var.health_check_path)
    port                = "traffic-port"
    protocol            = each.value.protocol
    timeout             = lookup(each.value, "health_check_timeout", var.health_check_timeout)
    unhealthy_threshold = lookup(each.value, "health_check_unhealthy_threshold", var.health_check_unhealthy_threshold)
  }

  deregistration_delay = lookup(each.value, "deregistration_delay", var.deregistration_delay)

  tags = merge(local.common_tags, {
    "Name"          = "${local.name_prefix}-tg-${each.key}"
    "PSA-Compliant" = "true"
  })
}

# Listener Rules for additional target groups
resource "aws_lb_listener_rule" "additional" {
  for_each = var.additional_target_groups

  listener_arn = aws_lb_listener.https.arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.additional[each.key].arn
  }

  dynamic "condition" {
    for_each = lookup(each.value, "host_header", null) != null ? [1] : []
    content {
      host_header {
        values = [each.value.host_header]
      }
    }
  }

  dynamic "condition" {
    for_each = lookup(each.value, "path_pattern", null) != null ? [1] : []
    content {
      path_pattern {
        values = [each.value.path_pattern]
      }
    }
  }

  tags = merge(local.common_tags, {
    "Name"          = "${local.name_prefix}-rule-${each.key}"
    "PSA-Compliant" = "true"
  })
}

# WAF Web ACL Association (if provided)
resource "aws_wafv2_web_acl_association" "this" {
  count        = var.waf_web_acl_arn != "" ? 1 : 0
  resource_arn = aws_lb.this.arn
  web_acl_arn  = var.waf_web_acl_arn
}

# Data sources
data "aws_caller_identity" "current" {}
data "aws_elb_service_account" "main" {}