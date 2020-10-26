output "system_mem_pct_usable_output" {
  value = datadog_monitor.system_mem_pct_usable[0].id
}