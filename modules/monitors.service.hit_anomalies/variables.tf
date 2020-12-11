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

variable "tags" {
  description = "List of custom tags to add" 
  type = list
  default = []
}