package terraform.signals.identity

rbac_changes[msg] {
  rc := input.resource_changes[_]
  rc.type == "azurerm_role_assignment"

  msg := sprintf("RBAC change: %s", [rc.address])
}

rbac_count := count(rbac_changes)
