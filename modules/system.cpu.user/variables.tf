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

variable "thresholds" {
  type = map
  default = {
    "alert"  = 10
    "warn"   = 5
  }
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