package terraform.classification

sensitive_types := {
  "azurerm_role_assignment",
  "azurerm_key_vault",
  "azurerm_network_security_group",
  "azurerm_firewall",
  "azurerm_kubernetes_cluster",
  "azurerm_private_endpoint",
  "azurerm_mssql_server",
  "azurerm_postgresql_flexible_server"
}

sensitive_changes[msg] {
  rc := input.resource_changes[_]

  sensitive_types[rc.type]

  msg := sprintf(
    "Sensitive resource modified: %s (%s)",
    [rc.address, rc.type]
  )
}
