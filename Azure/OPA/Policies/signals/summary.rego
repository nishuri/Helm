package terraform.signals.summary

import data.terraform.signals.complexity
import data.terraform.signals.destructive
import data.terraform.signals.security
import data.terraform.signals.sensitive
import data.terraform.signals.identity
import data.terraform.signals.environment

signals := {
  "total_changes": complexity.total_changes,
  "delete_count": destructive.delete_count,
  "replace_count": destructive.replace_count,
  "security_flags": security.security_findings,
  "sensitive_count": sensitive.count_sensitive,
  "rbac_count": identity.rbac_count,
  "environment": environment.env
}
