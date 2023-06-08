# How to set up Slack alerts

To set up alerting in your Slack workspace, you’re going to need a Slack API URL. Go to Slack -> Administration -> Manage apps.

![image](https://github.com/rio-ke/workman/assets/88568938/6e9dd024-0f5e-415e-be38-b7f820262fd1)

In the Manage apps directory, search for Incoming WebHooks and add it to your Slack workspace.

![image](https://github.com/rio-ke/workman/assets/88568938/bd1d23e9-ccbc-48d2-8033-9a2b8269fdd1)

> Next, specify in which channel you’d like to receive notifications from Alertmanager. (I’ve created #monitoring-infrastructure channel.) After you confirm and add Incoming WebHooks integration, webhook URL (which is your Slack API URL) is displayed. Copy it.

![image](https://github.com/rio-ke/workman/assets/88568938/379c33ef-2489-448f-806b-8c3c27b58a64)

> Then you need to modify the alertmanager.yml file. First, open subfolder alert_manager in your code editor and fill out your alertmanager.yml based on the template below. Use the url that you have just copied as slack_api_url.
*******************************************
_alert-manager.yml_

```yml
global:
  resolve_timeout: 1m
  slack_api_url: 'https://hooks.slack.com/services/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'
                           #paste newly generated slack token in slack_api_url
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
