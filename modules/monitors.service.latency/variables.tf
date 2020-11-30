variable "env" {
  description = "Environment"
  default = "prod"
}

variable "service" {
  description = "Service main parameters"
  type = map
  default = {
    "name" = "my_service_name"
    "operation_name" = "express.request"
  }
}

variable "latency_percentile" {
  description = "Service latency percentile: 50p, 75p, 90p, 95p, 99p"
  default = "90p"
}

variable "thresholds" {
  type = map
  default = {
    "alert"  = 0.3
    "warn"   = 0.2
  }
}

variable "notifications" {
  type = map
  default = {
    alert = ""
    warn = ""
    recovery = ""
    default = ""
    no_data = ""
  }
}

variable "owner" {
  description = "Owner of the monitor."
  default = "nxnarbais"
}