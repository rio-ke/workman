**basic_modules**

```yml
---
    - name: simple playbook
      host: all or localhost
      become: yes
      become_user: root
      
      tasks:
      - name: Install Apache web-server httpd
        apt:
        name: apache2
        state: present
      
      - name: start the web-seerver service
        service:
        name: apache2.services
        state: started
        
```       
      
