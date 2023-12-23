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
