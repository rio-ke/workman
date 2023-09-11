_Configure Docker Containers using Ansible_
---

_Create a docker image with ssh enabled_

```Dockerfile
FROM centos:centos8

RUN yum install net-tools -y

RUN yum install openssh-server -y

RUN ssh-keygen -A

RUN yum install passwd -y

RUN echo ankush | passwd root --stdin

CMD /usr/sbin/sshd && /bin/sh 
```

```cmd
docker build -t ansible/centos-ssh:v1 .
```

_Write a Playbook for configuring the containers_

```yml
---
- hosts: localhost
  tasks:
    - name: Launch a new container
      docker_container:
        name: my-container
        image: ansible/centos-ssh:v2
        state: started
        detach: yes
        interactive: yes
        tty: yes
        ports:
          - "8010:80"

    - name: Container details
      docker_container_info:
        name: "my-container"
      register: containerinfo

    - debug:
        var: containerinfo.container.NetworkSettings.IPAddress

    - name: Create inventory file
      template:
        src: ./inventory_template
        dest: /tmp/inventory/inventory_template

- hosts: docker
  tasks:
    - name: Install httpd
      package:
        name: httpd
        state: present

    - name: Start httpd
      command: /usr/sbin/httpd

    - name: Copy webpage
      copy:
        src: index.html
        dest: /var/www/html/index.html
```
