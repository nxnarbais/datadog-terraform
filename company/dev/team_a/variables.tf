variable "main_tags" {
  default = "owner:team_a,env:dev"
}

variable "env" {
  description = "Default environment value"
  default = "dev"
}

variable "service" {
  type = map
  default = {
    "name" = "my_team_b_service"
    "operation_name" = "http.request"
  }
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

variable "notifications" {
  type = map
  default = {
    email = ""
    slack = "@slack-my_channel"
  }
}

variable "owner" {
  description = "Owner of the current folder."
  default = "team_a"
}