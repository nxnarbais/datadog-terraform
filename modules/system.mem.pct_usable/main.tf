# Configure the Datadog provider
# provider "datadog" {
#   version = "2.8.0"
#   api_url = var.datadog_api_url
#   api_key = var.datadog_api_key
#   app_key = var.datadog_app_key
# }

resource "datadog_monitor" "log_mem_usable" {
  type                = "metric alert"
  name                = "Low memory usable {{host.name}}"
  query               = <<EOF
avg(last_5m):avg:system.mem.pct_usable{${var.selected_tags}} by {cloud_provider,env,host} < ${var.thresholds.alert}
EOF
  message = <<EOF
{{#is_alert}}
Alert | Memory usable is low

Instructions:

1. Check system metrics on [this dashboard](https://app.datadoghq.com/dash/integration/1?tpl_var_scope=host%3A{{host.name}})
2. If <CONDITION>, read [internal documentation]() for further instructions
3. If <CONDITION>, read [internal documentation]() for further instructions

${var.notifications.alert}
{{/is_alert}}

{{#is_warning}}
Warning | Memory usable is low

Instructions:

1. Check system metrics on [this dashboard](https://app.datadoghq.com/dash/integration/1?tpl_var_scope=host%3A{{host.name}})
2. Ensure responsible teams are aware. (Check the [infrastructure list to identify the team](https://app.datadoghq.com/infrastructure?filter={{host.name}}))

${var.notifications.warn}
{{/is_warning}} 

{{#is_recovery}}
We are recovering!

Instructions:

1. Write a post-mortem on a [notebook](https://app.datadoghq.com/notebook)

${var.notifications.recovery}
{{/is_recovery}}

Alert details: 

- cloud_provider: {{cloud_provider.name}}
- env: {{env.name}}
- host: {{host.name}}

${var.notifications.default}

EOF
  thresholds = {
    critical          = var.thresholds.alert
    warning           = var.thresholds.warn
  }
  notify_no_data      = true
  no_data_timeframe   = 120
  include_tags        = true
  tags                = ["standard:true", "terraform:true"]
}