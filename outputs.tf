// outputs.tf

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.this.dns_name
}

output "alb_zone_id" {
  description = "Hosted zone ID of the Application Load Balancer"
  value       = aws_lb.this.zone_id
}

output "alb_id" {
  description = "ID of the Application Load Balancer"
  value       = aws_lb.this.id
}

output "default_target_group_arn" {
  description = "ARN of the default target group"
  value       = aws_lb_target_group.default.arn
}

output "default_target_group_id" {
  description = "ID of the default target group"
  value       = aws_lb_target_group.default.id
}

output "https_listener_arn" {
  description = "ARN of the HTTPS listener"
  value       = aws_lb_listener.https.arn
}

output "http_listener_arn" {
  description = "ARN of the HTTP listener (if created)"
  value       = var.create_http_listener ? aws_lb_listener.http_redirect[0].arn : null
}

output "additional_target_group_arns" {
  description = "Map of additional target group names to their ARNs"
  value       = { for k, v in aws_lb_target_group.additional : k => v.arn }
}

output "additional_target_group_ids" {
  description = "Map of additional target group names to their IDs"
  value       = { for k, v in aws_lb_target_group.additional : k => v.id }
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for ALB access logs (if created)"
  value       = var.enable_access_logs && var.create_logs_bucket ? aws_s3_bucket.alb_logs[0].bucket : null
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket for ALB access logs (if created)"
  value       = var.enable_access_logs && var.create_logs_bucket ? aws_s3_bucket.alb_logs[0].arn : null
}