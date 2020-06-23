# Configure the Datadog provider
# provider "datadog" {
#   version = "2.8.0"
#   api_url = var.datadog_api_url
#   api_key = var.datadog_api_key
#   app_key = var.datadog_app_key
# }

resource "datadog_monitor" "service_error_rate" {
  type                = "metric alert"
  name                = "[Service] Error rate high on {{service.name}}"
  query               = <<EOF
sum(last_1h):100 * sum:${var.metrics.errors}{env:${var.env},${var.selected_tags}!exception_service_error_rate:true} by {env,team,service}.as_rate() / sum:${var.metrics.hits}{env:${var.env},${var.selected_tags}!exception_service_error_rate:true} by {env,team,service}.as_rate() > ${var.thresholds.alert}
EOF
  message = <<EOF
{{#is_alert}}
Service {{service.name}} error rate is too high

Instructions:

- Check stuffs

${var.notifications.alert}
{{/is_alert}} 

{{#is_no_data}}
Service {{service.name}}  is no longer monitored.

${var.notifications.no_data}
{{/is_no_data}} 

Alert details: 

- env: {{env.name}}
- team: {{team.name}}
- service: {{service.name}}
- thresholds: {{threshold}} 
- value: {{value}} 
- last_triggered_at: {{last_triggered_at}}
EOF
  thresholds = {
    critical          = var.thresholds.alert
    warning           = var.thresholds.warn
  }
  evaluation_delay    = 60
  notify_no_data      = true
  no_data_timeframe   = 120
  include_tags        = true
  tags                = ["standard:true", "terraform:true", "env:${var.env}", "service:all"]
}
