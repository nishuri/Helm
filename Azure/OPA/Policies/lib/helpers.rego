package terraform.lib.helpers

is_create(rc) {
  rc.change.actions[_] == "create"
}

is_update(rc) {
  rc.change.actions[_] == "update"
}

is_delete(rc) {
  rc.change.actions[_] == "delete"
}

is_replace(rc) {
  rc.change.actions == ["delete", "create"]
}

lower_contains(str, val) {
  contains(lower(str), lower(val))
}
