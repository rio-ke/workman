## moving the file from localhost to remote server



```yml
---
- name: file sharing
  hosts: v1
  become: true

  tasks:
    - name: Test server connection
      ping:

    - name: Copy a new "ntp.conf" file into place, backing up the original if it differs from the copied version
      ansible.builtin.copy:
        src: /home/rcms-lap-173/vsftpd-1
        dest: /home/server/ftp/
        owner: server
        group: server
        mode: "0644"
        # backup: true

    # - name: Copy file with owner and permission, using symbolic representation
    #   ansible.builtin.copy:
    #     src: /home/rcms-lap-173/vsftpd-1
    #     dest: /home/server/ftp/
    #     owner: root
    #     group: root
    #     # mode: u=rw,g=rw,o=rw
    #     mode: u+rw,g-wx,o-rwx


```
