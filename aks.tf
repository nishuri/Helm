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


Create Automated Backup and Recovery Processes

Description

As a Disaster Recovery (DR) analyst, I want to develop and document robust backup and restore procedures so that we can ensure the integrity and availability of data during a recovery.

Acceptance Criteria

• Backup procedures for all business-critical applications and data are clearly defined.

• Restore procedures are documented, including estimated recovery times.

• Procedures are tested to ensure they work as intended in a simulated disaster scenario.

• Documentation is stored centrally and accessible to relevant teams.

Test Coverage