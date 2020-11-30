module "monitor_service_latency" {
  source = "../../../modules/monitors.service.latency"
  env = var.env
  service = var.service
  latency_percentile = "90p"
  thresholds = {
    "alert"  = var.service_thresholds.latency-95p
    "warn"   = "0.05"
  }
  notifications = {
    alert = "${var.notifications.email} ${var.notifications.slack}"
    warn = ""
    recovery = ""
    default = ""
    no_data = "${var.notifications.slack}"
  }
  owner = var.owner
}

module "monitor_service_error_rate" {
  source = "../../../modules/monitors.service.error_rate"
  env = var.env
  service = var.service
  thresholds = {
    "alert"  = 10
    "warn"   = 5
  }
  notifications = {
    alert = "${var.notifications.email} ${var.notifications.slack}"
    warn = ""
    recovery = ""
    default = ""
    no_data = ""
  }
  owner = var.owner
}

# module "monitor_service_error_rate_with_min_hits" {
#   source = "../../../modules/monitors.service.error_rate_with_min_hits"
#   env = var.env
#   service = var.service
#   thresholds = {
#     "alert"  = 10
#     "warn"   = 5
#   }
#   minimum_hit_rate = "0.5"
#   notifications = {
#     alert = ""
#     warn = ""
#     recovery = ""
#     default = ""
#     no_data = ""
#   }
#   owner = var.owner
# }

module "monitor_service_hit_anomalies" {
  source = "../../../modules/monitors.service.hit_anomalies"
  env = var.env
  service = var.service
  notifications = {
    alert = "${var.notifications.email} ${var.notifications.slack}"
    warn = ""
    recovery = ""
    default = ""
    no_data = "${var.notifications.slack}"
  }
  owner = var.owner
}
