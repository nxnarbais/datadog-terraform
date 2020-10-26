output "system_disk_in_use_output" {
  value = datadog_monitor.system_disk_in_use[0].id
}