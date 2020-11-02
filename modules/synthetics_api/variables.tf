variable "datadog_api_url" {
  default = "https://api.datadoghq.com/"
}

variable "datadog_api_key" {
  default = ""
}

variable "datadog_app_key" {
  default = ""
}

variable "request" {
  default = {
    method = "GET"
    url = "https://www.google.com"
    headers = {
      Content-Type = "application/json"
      Authentication = "Token: 1234566789"
    }
  }
}

variable "frequency" {
  description = "How often the test should run (in seconds). Current possible values are 900, 1800, 3600, 21600, 43200, 86400, 604800 plus 60 if type=api or 300 if type=browser"
  default = 43200
}

variable "locations" {
  description= "List of locations to test from."
  default = ["aws:eu-central-1", "aws:eu-west-2"]
}

variable "assertions" {
  description = "Assertion values"
  default = {
    "statusCode" = "200"
    "responseTime" = 500 # ms
  }
}

variable "selected_tags" {
  description = "Synthetic tags. An array of tags. This is used to organize the tests."
  default = ["team:team_abc", "env:dev"]
}

variable "notifications" {
  type = map
  default = {
    email = "@john@doe.com @john@smith.com"
    slack = "@slack-my_channel"
  }
}