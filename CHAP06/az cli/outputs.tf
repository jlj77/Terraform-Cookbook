output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "storage_account_name" {
  value = azurerm_storage_account.sa.name
}

output "primary_web_host" {
  value = azurerm_storage_account.sa.primary_web_host
}
