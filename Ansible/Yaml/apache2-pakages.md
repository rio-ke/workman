**apache2 web-server install in ubuntu with yml file**

```yml

---
- name: simple playbook
  hosts: v1 #inventory_host_name
  become: true
  # become_user: root
  # become_method: sudo

  tasks:
    - name: ping the server
      ping:

    - name: Install update (Ubuntu)
      tags: always
      apt:
        upgrade: dist
        update_cache: yes

    - name: Install Apache web-server httpd
      apt:
        name: apache2
        state: present
        dpkg_options: force-confdef

    # - name: Enabling httpd service
    #   service:
    #     name: httpd
    #     enabled: yes
    - name: Stop the if installed "nginx" web-server service
      service:
        name: nginx
        state: stopped

    - name: start the web-server service
      service:
        name: apache2
        state: started

```

```yml

    - name: start the web-server service
      service:
        name: apache2
        state: stopped

    - name: start the web-server service
      service:
        name: apache2
        state: restarted

```
