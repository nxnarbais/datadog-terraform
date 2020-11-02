data "template_file" "synthetics_api" {
  template = file(
    "${path.module}/synthetics_api.tpl",
  )

  vars = {
    notifications_default = "${var.notifications["email"]} ${var.notifications["slack"]}}"
  }
}

resource "datadog_synthetics_test" "api_test" {
  type = "api"
  subtype = "http"
  name = "An API test on ${var.request["url"]}"
  message = data.template_file.synthetics_api.rendered
  tags = var.selected_tags
  request = {
    method = var.request["method"]
    url = var.request["url"]
  }
  request_headers = {
    Content-Type = var.request["headers"]["Content-Type"]
    Authentication = var.request["headers"]["Authentication"]
  }
  assertion {
    type = "statusCode"
    operator = "is"
    target = var.assertions["statusCode"]
  }
  assertion {
    type = "header"
    property = "content-type"
    operator = "contains"
    target = "application/json"
  }
  assertion {
    type = "responseTime"
    operator = "lessThan"
    target = var.assertions["responseTime"] # in ms
  }
  locations = var.locations
  options_list {
    tick_every = var.frequency

    retry {
      count = 2
      interval = 300
    }
  }

  status = "live"
}