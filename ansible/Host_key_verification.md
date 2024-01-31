Managing host key checking
---

**_inventory_** `OR` **_host_**

 Add the following.

```bash
ansible_ssh_extra_args='-o StrictHostKeyChecking=no'
```

$$OR$$

 Add the following in the `/home/ansible/ansible.cfg`

```bash
[defaults]
host_key_checking = False
```
