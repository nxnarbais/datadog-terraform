output "system_cpu_idle_output" {
  value = datadog_monitor.system_cpu_idle[0].id
}