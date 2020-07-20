data "template_file" "system_disk_used" {
  template = file(
    "${path.module}/runbook_templates/system_disk_used.tpl",
  )

  vars = {
    notification_receivers = var.system_disk_used_notification_receivers
  }
}

resource "datadog_monitor" "system_disk_used" {
  type  = "metric alert"
  name  = "[System][{host.name}] Disk space is running low."
  query = "min(last_5m):avg:system.disk.in_use{${var.system_disk_used_scope_string}} by {host,device} * 100 > ${var.system_disk_used_alert_threshold}"
  # More standarised Runbooks
  message = data.template_file.system_disk_used.rendered

  notify_no_data    = var.system_disk_used_notify_no_data
  no_data_timeframe = var.system_disk_used_no_data_timeframe
  include_tags      = true
  tags              = ["standard:true", "terraform:true"]

  # OOTB Resources for "host"
  count = var.host_monitors_enabled == "true" ? 1 : 0
}
