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

variable "cluster_name" {
  description = "Default cluster name value"
  default = "my_cluster"
}

variable "jvm_enabled" {
  description = "Set to true to have JVM metrics in the service dashboard"
  default = "true"
}

variable "network_enabled" {
  description = "Set to true to have Network data in the service dashboard"
  default = "true"
}

variable "service" {
  type = map
  default = {
    "service_name" = "my_service"
    "service_metric_root" = "trace.express.request"
    "service_operation_name" = "express.request"
  }
}

variable "service_slo" {
  description = "Main service SLO ID"
  default = "123456789abcdefghijkl"
}

variable "service_thresholds" {
  type = map
  default = {
    "hit-rate-min" = "5"
    "hit-rate-max" = "10"
    "error-rate" = "10"
    "latency-95p" = "0.10"
    "latency-50p" = "0.07"
  }
}

variable "service_dependencies" {
  type = list
  default = [{
    "service_name" = "my_service-mongodb"
    "service_metric_root" = "trace.mongodb.query"
    "service_operation_name" = "mongodb.query"
    "thresholds" = {
      "error-rate" = "5"
      "latency-95p" = "0.05"
      "latency-50p" = "0.03"
    }
  }, {
    "service_name" = "my_service-fs"
    "service_metric_root" = "trace.fs.operation"
    "service_operation_name" = "fs.operation"
    "thresholds" = {
      "error-rate" = "5"
      "latency-95p" = "0.03"
      "latency-50p" = "0.01"
    }
  }]
}
