# All hosts from prod with the standard exceptions
module "prod_systems" {
  source = "../../../modules/system"
  selected_tags = "${var.main_tags}"
  notifications = {
    email = "@john@doe.com @john@smith.com"
    slack = "@slack-my_channel"
  }
}
