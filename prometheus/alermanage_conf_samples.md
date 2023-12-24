**SLACK**

```yml
global:
  slack_api_url: https://hooks.slack.com/services/XXXXXXXX/XXXXXXXX/XXXXXXXX
  sms_api_url: https://api.twilio.com/2010-04-01/Accounts/XXXXXXXX/Messages.json

receivers:
- name: slack
  slack_configs:
  - channel: "#oncall"
- name: sms
  sms_configs:
  - to: "+1XXXXXXXXXX"
- name: email
  email_configs:
  - to: team@example.com

routes:
- match:
    severity: critical
  receiver: slack, sms
- match:
    severity: warning
  receiver: email
```

**SLACK_002**

```yml
global:
  resolve_timeout: 1m
  slack_api_url: 'https://hooks.slack.com/services/0000000/00000000000/0000000000000'

route:
  receiver: 'slack-notifications'

receivers:
  - name: 'slack-notifications'
    slack_configs:
    - channel: '#general'
      send_resolved: true     
      title: |-
        [{{ .Status | toUpper }}{{ if eq .Status "firing" }}:{{ .Alerts.Firing | len }}{{ end }}] {{ .CommonLabels.alertname }} for {{ .CommonLabels.job }}
        {{- if gt (len .CommonLabels) (len .GroupLabels) -}}
          {{" "}}(
          {{- with .CommonLabels.Remove .GroupLabels.Names }}
            {{- range $index, $label := .SortedPairs -}}
              {{ if $index }}, {{ end }}
              {{- $label.Name }}="{{ $label.Value -}}"
            {{- end }}
          {{- end -}}
          )
        {{- end }}
      text: >-
        {{ range .Alerts -}}
        *Alert:* {{ .Annotations.title }}{{ if .Labels.severity }} - `{{ .Labels.severity }}`{{ end }}
        *Description:* {{ .Annotations.description }}
        *Details:*
          {{ range .Labels.SortedPairs }} • *{{ .Name }}:* `{{ .Value }}`
          {{ end }}
        {{ end }}
```

_**MAIL-001**_

```yml
global:
  smtp_smarthost: 'smtp.gmail.com:587'
  smtp_from: 'infosec@radiantcashservices.com'
  smtp_auth_username: 'infosec@radiantcashservices.com'
  smtp_auth_password: 'Radiant#$123#$'
  smtp_require_tls: true
  smtp_hello: 10.0.0.5
  smtp_auth_identity: 'infosec@radiantcashservices.com'

route:
  group_by: ['alertname']
  group_wait: 30s
  group_interval: 50s
  repeat_interval: 1m  # Change the repeat_interval to 1 minute
  receiver: team-X-mails

  routes:
  - match:
      job: dailytest
    receiver: team-X-mails
    repeat_interval: 30m  # Repeat every 30 minutes for the 'dailytest' job

receivers:
- name: 'team-X-mails'
  email_configs:
  - to: 'infosec@radiantcashservices.com'
    send_resolved: true
    # Other email configurations...
```

* For mail smtp mail alert plz enable Less Secure Apps:
    - Ensure that you have allowed access for "Less secure app access" in your Gmail account settings. This is required for applications like Prometheus Alertmanager to use your Gmail account for sending emails.
