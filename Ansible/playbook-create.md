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

















