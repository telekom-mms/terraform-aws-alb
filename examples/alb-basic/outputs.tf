// examples/alb-basic/outputs.tf

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = module.alb.alb_arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "Hosted zone ID of the Application Load Balancer"
  value       = module.alb.alb_zone_id
}

output "alb_id" {
  description = "ID of the Application Load Balancer"
  value       = module.alb.alb_id
}

output "default_target_group_arn" {
  description = "ARN of the default target group"
  value       = module.alb.default_target_group_arn
}

output "https_listener_arn" {
  description = "ARN of the HTTPS listener"
  value       = module.alb.https_listener_arn
}

output "http_listener_arn" {
  description = "ARN of the HTTP listener"
  value       = module.alb.http_listener_arn
}

output "additional_target_group_arns" {
  description = "Map of additional target group ARNs"
  value       = module.alb.additional_target_group_arns
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for access logs"
  value       = module.alb.s3_bucket_name
}
