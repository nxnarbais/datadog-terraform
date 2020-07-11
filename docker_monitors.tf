# resource "datadog_monitor" "docker" {
#   count = var.docker_monitors_enabled == "true" ? 1 : 0
# }
