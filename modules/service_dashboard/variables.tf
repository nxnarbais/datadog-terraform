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

variable "description" {
  description = "Description of the dashboard"
  default = "Service dashboard blueprint to get started."
}

variable "env" {
  description = "Default environment value"
  default = "prod"
}

variable "cluster_name" {
  description = "Default cluster name value"
  default = "cluster_name"
}

variable "jvm_enabled" {
  description = "Set to true to have JVM metrics in the service dashboard"
  default = "false"
}

variable "network_enabled" {
  description = "Set to true to have Network data in the service dashboard"
  default = "false"
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
    "error-rate" = "10"
    "latency-95p" = "0.10"
    "latency-50p" = "0.07"
  }
}

variable "service_dependencies" {
  type = list
  default = [{
    "service_name" = "mydb"
    "service_metric_root" = "trace.mongodb.query"
    "service_operation_name" = "mongodb.query"
    "thresholds" = {
      "error-rate" = "5"
      "latency-95p" = "0.05"
      "latency-50p" = "0.03"
    }
  }]
}
