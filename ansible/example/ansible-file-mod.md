## changing the file and directories permisson mode

```ymal
---
- name: file module demo
  hosts: k
  become: true
  vars:
    myfile: "/home/server/file/index"
  tasks:
    - name: check permission for the index file
      ansible.builtin.file:
        path: "{{ myfile }}"
        owner: "root"
        group: "root"
        mode: "0777"

```

_execution_

```ansible
ansible-playbook playbook/file-mod.yml
```
