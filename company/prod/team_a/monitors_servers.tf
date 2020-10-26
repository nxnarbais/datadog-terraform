module "prod_low_mem_usable" {
  source = "../../../modules/system"
  selected_tags = "${var.main_tags}"
  notifications = {
    email = var.notifications.email
    slack = var.notifications.slack
  }
}

resource "datadog_monitor" "low_disk_available" {
  type                = "metric alert"
  name                = "Low disk available {{host.name}}"
  query               = <<EOF
avg(last_5m):avg:system.disk.free{${var.main_tags}} by {cloud_provider,env,host,device} < 100000
EOF
  message = <<EOF
{{#is_alert}}
Alert | Low disk available

Instructions:

- Check stuffs

${var.notifications.slack}
{{/is_alert}}

Alert details: 

- cloud_provider: {{cloud_provider.name}}
- env: {{env.name}}
- host: {{host.name}}
- device: {{device.name}}

EOF
  thresholds = {
    critical          = 100000
    warning           = 300000
  }
  notify_no_data      = true
  no_data_timeframe   = 120
  include_tags        = true
  tags                = ["standard:true", "terraform:true"]
}
