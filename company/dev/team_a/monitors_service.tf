# All services error rate
module "dev_services_error_rate_with_minimum_hits" {
  source = "../../../modules/service.error_rate_with_min_hits"
  env = "dev"
  selected_tags = "${var.main_tags}"
  metrics = {
    "hits"    = "trace.express.request.hits"
    "errors"  = "trace.express.request.errors"
  }
  notifications = {
    alert = "${var.notifications.email} ${var.notifications.slack}"
    no_data = "${var.notifications.slack}"
  }
  minimum_hit_rate = 5
}