module "tpl_module" {
  source = "tpl_source"
  tpl_local_name = {
    tpl_name = {
      location            = "westeurope"
      resource_group_name = "rg-mms-github"
      tags = {
        project     = "mms-github"
        environment = terraform.workspace
        managed-by  = "terraform"
      }
    }
  }
}
