module "synthetics_api_test_1" {
  source = "../../../modules/synthetics_api"
  selected_tags = var.main_tags_in_array
  notifications = {
    email = var.notifications.email
    slack = var.notifications.slack
  }
  request = {
    method = "GET"
    url = "https://www.my_company.website"
    headers = {
      Content-Type = "application/json"
      Authentication = "Token: 1234566789"
    }
  }
  frequency = 43200
  # locations = ["aws:eu-central-1", "aws:eu-west-2"] # keep default
  assertions = {
    "statusCode" = "404"
    "responseTime" = 200 # ms
  }
}