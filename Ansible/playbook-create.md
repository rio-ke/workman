# createing playbook


```yaml
---
- hosts: virtual
  become: true
  become_method: sudo
  ignore_errors: true
  # remote_user: server
  tasks:
    #   # - name: Ensure apache is installed and updated
    #   #   yum:
    #   #     name: httpd
    #   #     state: latest
    #   #   become: yes

    # - name: Install apache httpd  (state=present is optional)
    #   apt:
    #     name: apache2
    #     state: present
    - name: Update the repository cache and update package "nginx" to latest version using default release squeeze-backport
      apt:
        name: nginx
        state: present
        dpkg_options: force-confdef
        # default_release: squeeze-backports
        # update_cache: yes

```

ad-hoc cmd in terminal

```cmd
ansible-playbook playbooks/demo.yaml
```

**ERROR**

1. ![Missing sudo password](https://user-images.githubusercontent.com/88568938/210043561-40fb6cd7-874f-42b0-9a63-23278dfc05dc.png)

Add `sudo password` in ansible.cfg file 

```cfg
# (string) Password to pass to sudo
password=.
```

2. ![connecting-server-error](https://user-images.githubusercontent.com/88568938/210043719-cf130b7c-3e63-415a-bebb-6ebf9dcd3e73.png)

Add ` ignore_errors: true ` in demo.yaml file in the playbook folder 











