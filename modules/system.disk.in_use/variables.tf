variable "system_disk_in_use_enabled" {
  description = "Enable monitor on system.disk.in_use"
  default = "true"
}

variable "selected_tags" {
  description = "Selected tags"
  default = ""
}

variable "thresholds" {
  type = map
  default = {
    "alert"  = 0.9
    "warn"   = 0.8
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
