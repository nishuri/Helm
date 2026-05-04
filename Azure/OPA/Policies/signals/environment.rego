package terraform.signals.environment

import data.config

# Detect environment from:
# - resource address
# - tags (better)
# - workspace (best, if passed)

env := detected_env

detected_env = e {
  some rc
  rc := input.resource_changes[_]

  contains(lower(rc.address), "prod")
  e := "prod"
}

detected_env = e {
  some rc
  rc := input.resource_changes[_]

  contains(lower(rc.address), "uat")
  e := "uat"
}

detected_env = e {
  some rc
  rc := input.resource_changes[_]

  contains(lower(rc.address), "test")
  e := "test"
}

default detected_env = "dev"
