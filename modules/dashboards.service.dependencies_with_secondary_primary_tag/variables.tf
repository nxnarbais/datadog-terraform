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
    "name" = "my_name"
    "operation_name" = "express.request"
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
    "name" = "mydb"
    "operation_name" = "mongodb.query"
    "thresholds" = {
      "error-rate" = "5"
      "latency-95p" = "0.05"
      "latency-50p" = "0.03"
    }
  }]
}

variable "tags" {
  description = "List of custom tags to add" 
  type = list
  default = []
}