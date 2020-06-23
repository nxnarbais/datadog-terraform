# All services error rate
module "prod_services_error_rate" {
  source = "../../../modules/service.error_rate"
  # env = "prod"
  selected_tags = "${var.main_tags}"
  metrics = {
    "hits"    = "trace.express.request.hits"
    "errors"  = "trace.express.request.errors"
  }
  notifications = {
    alert = "${var.notifications.email} ${var.notifications.slack}"
    no_data = "${var.notifications.slack}"
  }
}