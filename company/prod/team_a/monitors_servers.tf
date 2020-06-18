/**
 * CPU
 */

# All hosts from prod without exception
module "prod_high_user_cpu" {
  source = "../../../modules/system.cpu.user"
  selected_tags = "${var.main_tags},env:prod,!exception_user_cpu:true"
  notifications = {
    alert = var.notifications.email
    warn = var.notifications.slack
    recovery = ""
    default = ""
  }
}

# All hosts from dev without exception
module "dev_high_user_cpu" {
  source = "../../../modules/system.cpu.user"
  selected_tags = "${var.main_tags},env:dev,!exception_user_cpu:true"
  notifications = {
    alert = var.notifications.slack
    warn = var.notifications.slack
    recovery = ""
    default = ""
  }
  thresholds = {
    "alert" = 15,
    "warn" = 10
  }
}

# Some specific hosts from prod
module "prod_high_user_cpu_critical" {
  source = "../../../modules/system.cpu.user"
  selected_tags = "${var.main_tags},env:prod,critical:true,exception_user_cpu:true"
  notifications = {
    alert = "${var.notifications.email} ${var.notifications.slack}"
    warn = var.notifications.slack
    recovery = ""
    default = ""
  }
  thresholds = {
    "alert" = 20,
    "warn" = 15
  }
}

/**
 * MEM
 */

# All hosts from dev without exception
module "prod_low_mem_usable" {
  source = "../../../modules/system.mem.pct_usable"
  selected_tags = "${var.main_tags},env:prod,!exception_mem_pct_usable:true"
  notifications = {
    alert = var.notifications.slack
    warn = var.notifications.slack
    recovery = ""
    default = var.notifications.slack
  }
  # thresholds = {
  #   "alert" = 15,
  #   "warn" = 10
  # }
}


/**
 * OTHERS
 */

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
