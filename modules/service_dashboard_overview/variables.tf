variable "datadog_api_url" {
  default = "https://api.datadoghq.com/"
}

variable "datadog_api_key" {
  default = ""
}

variable "datadog_app_key" {
  default = ""
}

variable "notify_list" {
  description = "List of handles of users to notify when changes are made to this dashboard."
  default = ["my_email@company.com"]
}

variable "env" {
  description = "Default environment value"
  default = "prod"
}

variable "service" {
  type = map
  default = {
    "service_name" = "my_service_name"
    "service_metric_root" = "trace.express.request"
    "service_operation_name" = "express.request"
  }
}

variable "service_thresholds" {
  type = map
  default = {
    "hit-rate-min" = "5"
    "hit-rate-max" = "50"
    "error-rate" = "10"
    "latency-95p" = "0.10"
    # "latency-50p" = "0.07"
  }
}

variable "dependency_dashboard_id" {
  description = "ID of the dependency dashboard for investigation"
  default = "abc-def-ghi"
}
