#!/bin/bash
host_directory_windows=jino
cat <<EOF > ./print.cfg
[defaults]
inventory            = $host_directory_windows
retry_files_enabled  = True
host_key_checking    = False
log_path             = /var/log/ansible.log
command_warnings     = False
deprecation_warnings = False
roles_path           = /opt/ansible/roles

#[privilege_escalation]
#become               = True
#become_method        = sudo
#become_user          = root
#become_ask_pass      = False


EOF
