data "template_file" "message" {
  template = file(
    "${path.module}/message.tpl",
  )

  vars = {
    notifications_alert = var.notifications.alert
    notifications_warn = var.notifications.warn
    notifications_recovery = var.notifications.recovery
    notifications_default = var.notifications.default
    notifications_no_data = var.notifications.no_data
  }
}

resource "datadog_monitor" "service_latency" {
  type                = "metric alert"
  name                = "[Service] Latency is high on ${var.service.name}"
  query               = <<EOF
avg(last_15m):avg:trace.${var.service.operation_name}.duration.by.service.${var.latency_percentile}{env:${var.env},service:${var.service.name}} > ${var.thresholds.alert}
EOF
  message = data.template_file.message.rendered
  thresholds = {
    critical          = var.thresholds.alert
    warning           = var.thresholds.warn
  }
  notify_no_data      = true
  no_data_timeframe   = 30
  include_tags        = true
  tags                = concat(["standard:true", "terraform:true", "env:${var.env}", "service:${var.service.name}", "owner:${var.owner}"], var.tags)
}
