locals {
  # Use environment variables if provided, otherwise use defaults
  project_name = var.project_name
  environment = var.environment
  name_prefix = var.name_prefix != "" ? var.name_prefix : (
    var.project_name != "" && var.environment != "" ? "${var.project_name}-${var.environment}" :
    ""
  )

  common_tags = merge(var.tags, {
    "Project"     = var.project_name
    "Environment" = var.environment
    "ManagedBy"   = "Terraform"
  })
}
