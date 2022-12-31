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

3. ![Screenshot from 2022-12-30 14-22-02](https://user-images.githubusercontent.com/88568938/210052413-a67199b7-6dfc-4516-816b-1826d9ee6c9e.png)

4. ![Screenshot from 2022-12-30 14-23-02](https://user-images.githubusercontent.com/88568938/210052451-d1e4d238-ee53-4ae3-917b-b2cb335092ee.png)

5. ![Screenshot from 2022-12-30 14-22-45](https://user-images.githubusercontent.com/88568938/210052475-eff8798c-6ed6-4a9e-9870-6c12a1e9baa5.png)

6. ![Screenshot from 2022-12-30 14-55-47](https://user-images.githubusercontent.com/88568938/210061013-aa66d0e8-bb6d-4d32-a581-fba01821c5b5.png)

7. ![Screenshot from 2022-12-30 15-09-58](https://user-images.githubusercontent.com/88568938/210061039-559826de-477d-462c-96a7-15975ee74bdd.png)

_resloved_

* Allows asible to run all users commands without a password
* login to ssh user
* go to `sudoer` file
* and add below cmd to conf file

```cfg
 ## Same thing without a password
username  ALL=(ALL)       NOPASSWD: ALL
 ```




