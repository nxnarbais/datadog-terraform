data "template_file" "message_error_rate" {
  template = file(
    "${path.module}/message_error_rate.tpl",
  )
}

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
  name                = "[Service][Composite] Error rate high on ${var.service.name}"
  query               = <<EOF
sum(last_15m):(100 * sum:trace.${var.service.operation_name}.errors{env:${var.env},service:${var.service.name}}.as_rate() / sum:trace.${var.service.operation_name}.hits{env:${var.env},service:${var.service.name}}.as_rate()) > ${var.thresholds.alert}
EOF
  message = data.template_file.message_error_rate.rendered
  thresholds = {
    critical          = var.thresholds.alert
    warning           = var.thresholds.warn
  }
  evaluation_delay    = 60
  notify_no_data      = true
  no_data_timeframe   = 30
  include_tags        = true
  tags                = ["standard:true", "terraform:true", "composite:true", "env:${var.env}", "service:${var.service.name}", "owner:${var.owner}"]
}

resource "datadog_monitor" "service_min_hits" {
  type                = "metric alert"
  name                = "[Service][Composite] Traffic too low ${var.service.name}"
  query               = <<EOF
sum(last_1h):sum:trace.${var.service.operation_name}.hits{env:${var.env},service:${var.service.name}}.as_count() < ${var.minimum_hit_rate}
EOF
  message = <<EOF
{{#is_alert}}
Service {{service.name}} is not reaching the minimum hit rate

Instructions:

- Nothing to do, some monitors may be deactivated because of this
{{/is_alert}} 

Alert details: 

- env: {{env.name}}
- team: {{team.name}}
- service: {{service.name}}
- thresholds: {{threshold}} 
- value: {{value}} 
- last_triggered_at: {{last_triggered_at}}
EOF
  thresholds = {
    critical          = var.minimum_hit_rate
  }
  notify_no_data      = true
  no_data_timeframe   = 120
  include_tags        = true
  tags                = ["standard:true", "terraform:true", "composite:true", "env:${var.env}", "service:${var.service.name}", "owner:${var.owner}"]
}

resource "datadog_monitor" "service_error_rate_with_min_hit_rate" {
  name    = "[Service] Error rate high on ${var.service.name} with minimum hit rate reached"
  type    = "composite"
  query   = "${datadog_monitor.service_error_rate.id} && !${datadog_monitor.service_min_hits.id}"
  message = data.template_file.message.rendered

  notify_no_data      = true
  include_tags        = true
  tags                = ["standard:true", "terraform:true", "composite:true", "env:${var.env}", "service:${var.service.name}", "owner:${var.owner}"]
}
