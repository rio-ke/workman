# How to regenrate Slack-api-token in linux server

- Go to slack workspace

Then click on Name in Light top in slack portal

then click `administration`

```
Administration > manage app
```

then windows will pop up

go to nxt window

in `search app dircetory`

type `webhook`

```
Incoming webhook
```

Incoming webhooks page will open

click on `Configuration`

```
Posts to #general as incoming-webhook

```

- Edit Configuration

- Integration settings

- Webhook URL

```
Regenerate
```

then copy the url

```
https://hooks.slack.com/services/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jnak
```

Now go to linux monitor server

ad in `alertmaganaer.yml` file

then restart alertmanager

