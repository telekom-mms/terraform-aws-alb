variable "tpl_local_name" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}

locals {
  default = {
    // resource definition
    tpl_local_name = {
      name = ""
      tags = {}
    }
  }

  // compare and merge custom and default values
  tpl_local_name_values = {
    for tpl_local_name in keys(var.tpl_local_name) :
    tpl_local_name => merge(local.default.tpl_local_name, var.tpl_local_name[tpl_local_name])
  }

  // deep merge of all custom and default values
  tpl_local_name = {
    for tpl_local_name in keys(var.tpl_local_name) :
    tpl_local_name => merge(
      local.tpl_local_name_values[tpl_local_name],
      {}
    )
  }
}
