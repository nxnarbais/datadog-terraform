{{#is_alert}}
Alert | Inodes utilization high

Instructions:

1. Check system metrics on [this dashboard](https://app.datadoghq.com/dash/integration/1?tpl_var_scope=host%3A{{host.name}})
2. If <CONDITION>, read [internal documentation]() for further instructions
3. If <CONDITION>, read [internal documentation]() for further instructions

${notifications_alert}
{{/is_alert}}

{{#is_warning}}
Warning | Inodes utilization high

Instructions:

1. Check system metrics on [this dashboard](https://app.datadoghq.com/dash/integration/1?tpl_var_scope=host%3A{{host.name}})
2. Ensure responsible teams are aware. (Check the [infrastructure list to identify the team](https://app.datadoghq.com/infrastructure?filter={{host.name}}))

${notifications_warn}
{{/is_warning}} 

{{#is_recovery}}
We are recovering!

Instructions:

1. Write a post-mortem on a [notebook](https://app.datadoghq.com/notebook)

${notifications_recovery}
{{/is_recovery}}

Alert details: 

- cloud_provider: {{cloud_provider.name}}
- env: {{env.name}}
- host: {{host.name}}
- device: {{device.name}}
- inodes used: {{value}}%

${notifications_default}