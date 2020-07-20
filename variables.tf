variable "host_monitors_enabled" {
  default     = "true"
  description = "Provision default hosts monitors."
}

variable "docker_monitors_enabled" {
  default     = "true"
  description = "Provision default docker monitors."
}

variable "system_disk_used_scope_string" {
  default     = ""
  description = "Comma seperated string to scope and exclude tags, e.g. account:demo3,!env:test,!env:datad0g.com"
}

variable "system_disk_used_alert_threshold" {
  default = 80
}

variable "system_disk_used_notify_no_data" {
  default = true
}

variable "system_disk_used_no_data_timeframe" {
  default = 120
}

variable "system_disk_used_notification_receivers" {
  default     = ""
  description = "Space seperated string of receivers for this monitor notification, e.g. @slack-infra @daniel.lin@datadoghq.com"
}
