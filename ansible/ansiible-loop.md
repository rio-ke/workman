## ansible-loop

```yml 
---
- name: host user find
  hosts: k
  become: true
  tasks:
    - name: Add several users
      ansible.builtin.user:
        name: "{{ item }}"
        state: present
        groups: "server"
      loop:
        - ken
        - nick

```