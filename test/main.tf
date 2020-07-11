module "datadog_ootb" {
  # source = "https://github.com/nxnarbais/terraform-datadog.git"
  source = "../../terraform-datadog"

  # configurable option to swtich off a seriers of host resources
  host_monitors_enabled = "true"
  # customisable configurations
  system_disk_used_scope_string           = "env:shop.ist,!env:test"
  system_disk_used_notification_receivers = "@slack-scott-demo @daniel.lin@datadoghq.com"
}
