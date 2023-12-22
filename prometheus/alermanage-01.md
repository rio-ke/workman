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
    slack_api_url: 'https://hooks.slack.com/services/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'

   route:
    receiver: 'slack-notifications'

   receivers:
   - name: 'slack-notifications'
    slack_configs:
    - channel: '#monitoring-instances'
      send_resolved: true
      icon_url: https://avatars3.githubusercontent.com/u/3380462
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
