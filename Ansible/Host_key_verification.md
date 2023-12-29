

_inventory_

* Add the following.

```conf
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```
_host_

* Add the following.
```conf
ansible_ssh_extra_args='-o StrictHostKeyChecking=no'
```
