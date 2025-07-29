# terraform-template

This is a template for terraform modules.

## Usage

replace the following content from template

`.github/settings.json`

replace the following placeholder

* tpl_resources

```example
tpl_resources  = azurerm container
```

`examples/*`

replace the following placeholder

* tpl_module
* tpl_source
* tpl_local_name
* tpl_name

```example
tpl_module     = container
tpl_source     = registry.terraform.io/telekom-mms/container/azurerm
tpl_local_name = container_registry
tpl_name       = crmms
```

`main.tf`

replace the following placeholder

* tpl_provider
* tpl_module

```example
tpl_module        = container
tpl_provider      = azurerm
tpl_resource_type = azurerm_container_registry
tpl_local_name    = container_registry
```

`outputs.tf`

replace the following placeholder

* tpl_resource_type
* tpl_local_name

```example
tpl_resource_type = azurerm_container_registry
tpl_local_name    = container_registry
```

`variables.tf`

replace the following placeholder

* tpl_local_name

```example
tpl_local_name = container_registry
```
