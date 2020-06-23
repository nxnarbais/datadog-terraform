# Service backup
module "prod_backup" {
  source = "../../../modules/backup"
  service_name = "my_app_with_critical_data"
  notifications = {
    alert = "${var.notifications.email} ${var.notifications.slack}"
    no_data = "${var.notifications.slack}"
  }
}
