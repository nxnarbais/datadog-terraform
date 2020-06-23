# Backup failing
resource "datadog_monitor" "backup_failing" {
  type                = "event alert"
  name                = "[Backup] Failing for past 2 days"
  query               = "events('priority:all Backup success tags:service:${var.service_name},role:backup').rollup('count').last('2d') < 1"
  message = <<EOF
{{#is_alert}}
Backup not completed in 48 hours.

Instructions:

- Ssh to server: `ssh user@ip_address`
- Navigate to relevant folder: `cd /navigate/to/relevant/folder`
- Fix the issue (try to run `./download.sh`)

${var.notifications.alert}
{{/is_alert}} 

Alert details: 

- {{event.id}}
- {{event.title}}
- {{event.text}}
- {{event.host.name}}
EOF
  thresholds = {
    critical          = 1
  }
  include_tags        = true
  tags                = ["service:${var.service_name}", "role:backup"]
}

# Backup folder is too large
resource "datadog_monitor" "backup_folder_too_large" {
  type                = "metric alert"
  name                = "[Backup] Folder too large"
  query               = "avg(last_15m):sum:system.disk.directory.bytes{role:backup} by {name,env,host,cloud_provider,region} > 100000000"
  message = <<EOF
{{#is_alert}}
Directory with role `backup` is too large.

Instructions:

- Ssh to server: `ssh user@{{host.ip}}`
- Navigate to relevant folder: `cd {{name.name}}`
- Delete old backups: `rm -rf 201912*`

${var.notifications.alert}
{{/is_alert}} 

{{#is_no_data}}
Directory is no longer monitored.

${var.notifications.no_data}
{{/is_no_data}} 

Alert details: 

- cloud_provider: {{cloud_provider.name}} 
- env: {{env.name}}
- region: {{region.name}} 
- host.name: {{host.name}}
- host.ip: {{host.ip}}
- name: {{name.name}} 
- thresholds: {{threshold}} 
- value: {{value}} 
- last_triggered_at: {{last_triggered_at}}
EOF
  thresholds = {
    critical          = 100000000
  }
  include_tags        = true
  tags                = ["service:all", "role:backup"]
}