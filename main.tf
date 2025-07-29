/**
* # tpl_module
*
* This module manages the tpl_provider tpl_module resources, see https://registry.terraform.io/providers/tpl_provider/latest/docs.
*
* For more information about the module structure see https://telekom-mms.github.io/terraform-template.
*
*/

resource "tpl_resource_type" "tpl_local_name" {
  for_each = var.tpl_local_name

  name = local.tpl_local_name[each.key].name == "" ? each.key : local.tpl_local_name[each.key].name

  tags = local.tpl_local_name[each.key].tags
}
