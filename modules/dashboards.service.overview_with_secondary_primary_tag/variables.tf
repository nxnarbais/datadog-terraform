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

variable "secondary_primary_tag" {
  description = "Set the key of the secondary primary tag and its default value"
  default = {
    "key" = "NA" # Must be different than NA for it to work
    "value" = "emea"
  }
}

variable "service" {
  type = map
  default = {
    "name" = "my_name"
    "operation_name" = "express.request"
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

variable "service_slo"{
  description = "Main service SLO ID"
  default = "3a5c8574eb61542db1729f062ba7d43d"
}

variable "dependency_dashboard_id" {
  description = "ID of the dependency dashboard for investigation"
  default = "abc-def-ghi"
}
