locals {
  name_prefix = var.name_prefix != "" ? var.name_prefix : "${var.project_name}-${var.environment}"

  access_logs_prefix_trimmed = trim(var.access_logs_prefix, "/")
  access_logs_resource_path  = local.access_logs_prefix_trimmed != "" ? "${local.access_logs_prefix_trimmed}/AWSLogs/${data.aws_caller_identity.current.account_id}/*" : "AWSLogs/${data.aws_caller_identity.current.account_id}/*"

  common_tags = merge(var.tags, {
    "Project"       = var.project_name
    "Environment"   = var.environment
    "ManagedBy"     = "Terraform"
    "PSA-Compliant" = "true"
  })
}
