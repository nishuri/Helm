package terraform.signals.security

security_findings[msg] {
  rc := input.resource_changes[_]
  rc.type == "azurerm_storage_account"

  after := rc.change.after
  after.public_network_access_enabled == true

  msg := sprintf("Storage public access enabled: %s", [rc.address])
}

security_findings[msg] {
  rc := input.resource_changes[_]
  rc.type == "azurerm_key_vault"

  after := rc.change.after
  after.public_network_access_enabled == true

  msg := sprintf("KeyVault public access enabled: %s", [rc.address])
}

security_findings[msg] {
  rc := input.resource_changes[_]
  rc.type == "azurerm_network_security_rule"

  after := rc.change.after
  lower(after.access) == "allow"
  lower(after.direction) == "inbound"
  after.source_address_prefix == "*"

  msg := sprintf("NSG open to world: %s", [rc.address])
}
