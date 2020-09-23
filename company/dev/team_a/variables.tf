variable "datadog_api_url" {
  default = "https://api.datadoghq.com/"
}

variable "datadog_api_key" {
  default = ""
}

variable "datadog_app_key" {
  default = ""
}

variable "main_tags" {
  default = "owner:team_a,env:dev"
}

variable "notifications" {
  type = map
  default = {
    email = ""
    slack = ""
  }
}