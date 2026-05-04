package terraform.signals.sensitive

import data.config

sensitive_changes[msg] {
  rc := input.resource_changes[_]
  config.sensitive_types[_] == rc.type

  msg := sprintf("Sensitive resource touched: %s", [rc.address])
}

count_sensitive := count(sensitive_changes)
