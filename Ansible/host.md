



*  **ansible_host**: – Name of the server you want to connect to
*  **ansible_connection**: – This is the connection type you want to use; default is SSH, but below are the other options if you SSH don’t work in your*
*  **local**: – To deploy tasks locally on the Ansible control node
*  **docker**: – To deploy tasks on containers on the remote host, using local Docker container client. Below are supported parameters for
   *  **ansible_host**: – Name of Docker
   *   **ansible_user**: – User must exists inside
   *  **ansible_pasword**: –Password for above
   *  **ansible_become**: – If set to true, then escalated privileges will be
   *  **ansible_docker_extra_args**: – Strings with any additional arguments understood by
   *  **ansible_port**: – Connection port number if not default 22
*  **ansible_user**: – Username to use when connecting to remote
*  **ansible_password**: – Password to connect to remote hosts, don’t store in plain text, use ansible vault.
*  **ansible_ssh_private_key_file**: – Private key file to use if not using ssh-agent
*  **ansible_become**: – To allow force privileges
*  **ansible_become_method**: – To set privileges escalation method
*  **ansible_become_user**: – To set the privilege user
*  **ansible_become_password**: – To give the password for the escalated user. don’t store in plain text, use ansible
*  **ansible_shell_type**: If don’t need to use sh shell but csh shell or
*  **ansible_python_interpreter**: – To set the python interpreter on target machines, if there are multiple versions of python or the python executable is named other than python like 6
*  **ansible_*_interpreter**: –Similar to above and works for anything like Ruby

