# How to set up Gmail alerts

It isn’t recommended that you use your personal password for this, so you should create an `App Password`. To do that, go to `Account Settings` -> `Security` -> Signing in to Google -> `App password` (if you don’t see App password as an option, you probably haven’t set up 2-Step Verification and will need to do that first). Copy the newly created password.
**********

![image](https://github.com/rio-ke/workman/assets/88568938/a2405d70-f543-416b-a4b2-4edb1732b3a4)


You’ll need to update the content of your alertmanager.yml again. The content should look similar to the example below. Don’t forget to replace the email address with your own email address, and the password with your new app password.

```yml
global:
  resolve_timeout: 1m

route:
  receiver: 'gmail-notifications'

receivers:
- name: 'gmail-notifications'
  email_configs:
  - to: monitoringinstances@gmail.com
    from: monitoringinstances@gmail.com
    smarthost: smtp.gmail.com:587
    auth_username: monitoringinstances@gmail.com
    auth_identity: monitoringinstances@gmail.com
    auth_password: password
    send_resolved: true
```
