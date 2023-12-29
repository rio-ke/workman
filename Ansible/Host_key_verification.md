# Managing host key checking
---

**_inventory_** `OR` **_host_**

* Add the following.

```bash
ansible_ssh_extra_args='-o StrictHostKeyChecking=no'
```

$$OR$$

