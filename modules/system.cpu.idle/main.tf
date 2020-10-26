data "template_file" "system_cpu_idle" {
  template = file(
    "${path.module}/system.cpu.idle.tpl",
  )

  vars = {
    notifications_alert = var.notifications.alert
    notifications_warn = var.notifications.warn
    notifications_recovery = var.notifications.recovery
    notifications_default = var.notifications.default
  }
}

resource "datadog_monitor" "system_cpu_idle" {
  type                = "metric alert"
  name                = "Low cpu usable {{host.name}}"
  query               = <<EOF
avg(last_15m):avg:system.cpu.idle{${var.selected_tags}} by {cloud_provider,env,host} < ${var.thresholds.alert}
EOF
  message = data.template_file.system_cpu_idle.rendered
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

  count = var.system_cpu_idle_enabled == "true" ? 1 : 0
}