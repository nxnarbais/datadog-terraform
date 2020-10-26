variable "system_cpu_load_norm_5_enabled" {
  description = "Enable monitor on system.cpu.load.norm.5"
  default = "true"
}

variable "selected_tags" {
  description = "Selected tags"
  default = ""
}

variable "thresholds" {
  type = map
  default = {
    "alert"  = 1.3
    "warn"   = 1
  }
}

variable "locked" {
  description = "A boolean indicating whether changes to to this monitor should be restricted to the creator or admins."
  default = true
}

variable "notifications" {
  type = map
  description = "Space seperated string of receivers for this monitor notification in the different situations."
  default = {
    alert = ""
    warn = ""
    recovery = ""
    default = ""
  }
}
