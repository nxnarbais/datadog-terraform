{{#is_alert}}
Alert | Service {{service.name}} hit rate abnormal

Instructions:

1. Check system metrics on [this dashboard](https://app.datadoghq.com/dash/integration/1?tpl_var_scope=host%3A{{host.name}})
2. If <CONDITION>, read [internal documentation]() for further instructions
3. If <CONDITION>, read [internal documentation]() for further instructions

${notifications_alert}
{{/is_alert}}

{{#is_recovery}}
We are recovering!

Instructions:

1. Write a post-mortem on a [notebook](https://app.datadoghq.com/notebook)

${notifications_recovery}
{{/is_recovery}}

Alert details: 

- env: {{env.name}}
- team: {{team.name}}
- service: {{service.name}}
- thresholds: {{threshold}} 
- value: {{value}} 
- last_triggered_at: {{last_triggered_at}}

${notifications_default}