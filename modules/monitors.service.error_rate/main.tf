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

resource "datadog_monitor" "service_error_rate" {
  type                = "metric alert"
  name                = "[Service] Error rate high on ${var.service.name}"
  query               = <<EOF
sum(last_15m):(100 * sum:trace.${var.service.operation_name}.errors{env:${var.env},service:${var.service.name}}.as_rate() / sum:trace.${var.service.operation_name}.hits{env:${var.env},service:${var.service.name}}.as_rate()) > ${var.thresholds.alert}
EOF
  message = data.template_file.message.rendered
  thresholds = {
    critical          = var.thresholds.alert
    warning           = var.thresholds.warn
  }
  evaluation_delay    = 60
  notify_no_data      = true
  no_data_timeframe   = 30
  include_tags        = true
  tags                = concat(["standard:true", "terraform:true", "env:${var.env}", "service:${var.service.name}", "owner:${var.owner}"], var.tags)
}


