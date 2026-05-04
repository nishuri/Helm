package terraform.classification

replacement_changes[msg] {
  rc := input.resource_changes[_]

  rc.change.actions == ["delete", "create"]

  msg := sprintf(
    "Replacement detected: %s",
    [rc.address]
  )
}
