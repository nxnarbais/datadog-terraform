data "template_file" "system_disk_in_use" {
  template = file(
    "${path.module}/system.disk.in_use.tpl",
  )

  vars = {
    notifications_alert = var.notifications.alert
    notifications_warn = var.notifications.warn
    notifications_recovery = var.notifications.recovery
    notifications_default = var.notifications.default
  }
}

resource "datadog_monitor" "system_disk_in_use" {
  type                = "metric alert"
  name                = "Low cpu usable {{host.name}}"
  query               = <<EOF
avg(last_5m):avg:system.disk.in_use{${var.selected_tags},!device:tmpfs,!device:devtmpfs,!device:/dev/loop0,!device:/dev/loop1,!device:/dev/loop2,!device:/dev/loop3,!device:/dev/loop4} by {cloud_provider,env,host,device} > ${var.thresholds.alert}
EOF
  message = data.template_file.system_disk_in_use.rendered
  thresholds = {
    critical          = var.thresholds.alert
    warning           = var.thresholds.warn
  }
  new_host_delay      = 300 # Time (in seconds) to delay evaluation, as a non-negative integer.
  notify_no_data      = true # A boolean indicating whether this monitor will notify when data stops reporting.
  no_data_timeframe   = 30 # The number of minutes before a monitor will notify when data stops reporting.
  include_tags        = true # A boolean indicating whether notifications from this monitor automatically insert its triggering tags into the title. Defaults to true.
  tags                = ["standard:true", "terraform:true", "type:system"]
  locked              = var.locked # A boolean indicating whether changes to to this monitor should be restricted to the creator or admins. Defaults to False.
  # timeout_h           = 3 # The number of hours of the monitor not reporting data before it will automatically resolve (Mostly for sparce metrics or event monitors)

  count = var.system_disk_in_use_enabled == "true" ? 1 : 0
}