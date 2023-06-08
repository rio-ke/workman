# How to regenrate Slack-api-token in linux server

**_Go to slack workspace_**

Then click on Name in Light top in slack portal

_Then click administration_

```
Administration > manage app
```
![Screenshot from 2023-06-08 10-07-13](https://github.com/rio-ke/workman/assets/88568938/76c1af95-5750-4ec9-bebe-00c5672d7e35)


**Go to nxt window**

Inside `search app dircetory`

Type `webhook` 

![Screenshot from 2023-06-08 10-09-25](https://github.com/rio-ke/workman/assets/88568938/ff2df5be-f560-4a20-9e29-90c368aa7324)

```
Incoming webhook
```

**_Incoming webhooks page will open_**

Click on `Configuration`

![Screenshot from 2023-06-08 10-10-52](https://github.com/rio-ke/workman/assets/88568938/4ebacc3e-6217-49bb-9b13-83d88479bb7f)


```
Posts to #general as incoming-webhook

```

- Edit Configuration

- Integration settings

- Webhook URL

```
Regenerate
```
![Screenshot from 2023-06-08 10-16-25](https://github.com/rio-ke/workman/assets/88568938/1c94c592-3442-4c48-8c24-a7ebc80178a2)

**Then copy the url**

```
https://hooks.slack.com/services/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jnak
```

**_Now go to linux monitor server_**

ad in `alertmaganaer.yml` file

Then restart alertmanager
![Screenshot from 2023-06-08 10-18-42](https://github.com/rio-ke/workman/assets/88568938/31ef000a-794f-4726-91eb-396864d68063)


