package terraform.classification

destructive_changes[msg] {
  rc := input.resource_changes[_]

  rc.change.actions[_] == "delete"

  msg := sprintf(
    "Destructive change detected: %s",
    [rc.address]
  )
}
