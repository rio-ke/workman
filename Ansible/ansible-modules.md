# ansible modules

Ansible modules are units of code that can control system resources or execute system commands. Ansible provides a module library that you can execute directly on remote hosts or through playbooks. You can also write custom modules.


https://docs.ansible.com/ansible/2.9/modules/list_of_all_modules.html


Ansible modules are the building blocks of Ansible automation. They are small, reusable scripts or programs that perform specific tasks on managed hosts. Modules are used within Ansible playbooks to enforce the desired state of a system. Ansible provides a large number of built-in modules for common tasks, and you can also create custom modules to extend Ansible's functionality. Here are some commonly used Ansible modules:

1. Shell Modules:

command: Executes a shell command on the target host.
shell: Similar to command but runs the command through a shell, allowing the use of shell features and redirection.
File Modules:

copy: Copies files from the Ansible control machine to the target host.
file: Manages file and directory attributes on the target host.
template: Uses Jinja2 templates to copy files with variables and conditionals.

2. Package Modules:

apt, dnf, yum, zypper, pkgng, homebrew, etc.: Package managers for various operating systems. Used to manage software packages.

3. Service Modules:

service: Manages services on the target host. Can start, stop, enable, or disable services.
User Modules:

user: Manages user accounts on the target host. Can create, modify, or delete users.

4. Group Modules:

group: Manages groups on the target host. Can create, modify, or delete groups.
System Modules:

hostname: Manages the system's hostname.
reboot: Reboots the target host.

5. Networking Modules:

ios_command, ios_config, nxos_command, nxos_config, etc.: Modules for managing network devices.
ping: Sends ICMP ping requests to hosts to check their availability.

6. Database Modules:

mysql_db, postgresql_db: Manages databases.
mysql_user, postgresql_user: Manages database users.

7. Cloud Modules:

ec2: Manages Amazon EC2 instances.
azure_rm: Manages resources in Microsoft Azure.
gcp_compute: Manages Google Cloud Platform resources.

8. Container Modules:

docker_container: Manages Docker containers.
k8s: Manages Kubernetes resources.

9. Monitoring Modules:

nagios: Manages Nagios hosts and services.
zabbix_*: Modules for managing Zabbix hosts, items, and triggers.

10. Custom Modules:

You can create custom modules in Python or other languages to extend Ansible's functionality for your specific needs.
