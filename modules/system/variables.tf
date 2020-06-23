variable "datadog_api_url" {
  default = "https://api.datadoghq.com/"
}

variable "datadog_api_key" {
  default = ""
}

variable "datadog_app_key" {
  default = ""
}

variable "selected_tags" {
  description = "Selected tags"
  default = ""
}

variable "notifications" {
  type = map
  default = {
    alert = ""
    warn = ""
    recovery = ""
    default = ""
  }
}