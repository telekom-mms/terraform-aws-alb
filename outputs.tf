output "tpl_local_name" {
  description = "Outputs all attributes of resource_type."
  value = {
    for tpl_local_name in keys(tpl_resource_type.tpl_local_name) :
    tpl_local_name => {
      for key, value in tpl_resource_type.tpl_local_name[tpl_local_name] :
      key => value
    }
  }
}

output "variables" {
  description = "Displays all configurable variables passed by the module. __default__ = predefined values per module. __merged__ = result of merging the default values and custom values passed to the module"
  value = {
    default = {
      for variable in keys(local.default) :
      variable => local.default[variable]
    }
    merged = {
      tpl_local_name = {
        for key in keys(var.tpl_local_name) :
        key => local.tpl_local_name[key]
      }
    }
  }
}
