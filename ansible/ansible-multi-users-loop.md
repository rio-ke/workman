# creating multiple users using loop structure with variables(lists)

**syntax**

```yml
---
- name: finding shell command with conditional and loop and variables
  hosts: node
  become: yes
  vars:
    ans_er:
      - kendanic
      - kentnick
      - rosario
  tasks:
    - name: creating users in ubuntu server
      ansible.builtin.user:
        name: "{{ item }}"
        state: present
        shell: /bin/bash
        groups: root
        # append: yes
      register: created
      loop: "{{ ans_er }}"
    - debug:
        msg: "{{ created | json_query('results[*].shell') }}"

```

- whenever using loop we have to use the json_query in debug 'msg'

```yml
- debug:
        msg: "{{ created | json_query('results[*].shell') }}"
```
