**apache2 web-server install in ubuntu with yml file**

```yml

---
- name: simple playbook
  hosts: virtual
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
