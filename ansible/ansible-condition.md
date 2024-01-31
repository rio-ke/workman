## ansible-conditions   

```yml
---
- hosts: k
  become: yes
  tasks:
    - name: Shut down "ubuntu" flavored systems
      ansible.builtin.command: /sbin/shutdown -t now
      when: ansible_facts['os_family'] == "ubuntu"
# - name: Show facts available on the system
#   ansible.builtin.debug:
#     var: ansible_facts
# #Here is a sample conditional based on a fact:

```