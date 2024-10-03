resource "azurerm_kubernetes_cluster" "example" {

  dynamic "node_os_channel_upgrade" {
    for_each = var.environment == "dev" ?  : []
    content {
      node_os_channel_upgrade = "NodeImage"
    }
  }

  dynamic "maintenance_window_node_os" {
    for_each = var.environment == "dev" ?  : []
    content {
      frequency   = "Weekly"
      interval    = 1
      day_of_week = "Monday"
      start_time  = "00:00"
      start_date  = "2024-10-07T00:00:00Z"
      utc_offset  = "+00:00"
      duration    = 6
    }
  }
}
