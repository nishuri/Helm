package terraform.signals.destructive

delete_count := count([rc |
  rc := input.resource_changes[_]
  rc.change.actions[_] == "delete"
])

replace_count := count([rc |
  rc := input.resource_changes[_]
  rc.change.actions == ["delete", "create"]
])

has_destructive {
  delete_count > 0
}

has_replace {
  replace_count > 0
}
