module "system" {
  # more source options: https://www.terraform.io/docs/modules/sources.html
  source = "github.com/nxnarbais/terraform-datadog//modules/system?ref=0.1"
  selected_tags = "${var.main_tags}"
  notifications = {
    email = var.notifications.email
    slack = var.notifications.slack
  }
}
