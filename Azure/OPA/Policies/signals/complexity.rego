package terraform.signals.complexity

total_changes := count(input.resource_changes)

creates := count([rc |
  rc := input.resource_changes[_]
  rc.change.actions[_] == "create"
])

updates := count([rc |
  rc := input.resource_changes[_]
  rc.change.actions[_] == "update"
])
