Set Up SSH Access for the User
---

```bash
# Generate SSH keys (if not already created)
su - your_ssh_user -c "ssh-keygen -t rsa"

# Configure SSH server (if not already configured)
# The configuration file location might vary based on the container image.
# For example, /etc/ssh/sshd_config for Debian/Ubuntu-based images.
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Restart the SSH server
service ssh restart

# Add the user's public key to authorized_keys
cat /home/your_ssh_user/.ssh/id_rsa.pub >> /home/your_ssh_user/.ssh/authorized_keys

# Set correct permissions
chown -R your_ssh_user:your_ssh_user /home/your_ssh_user/.ssh/

```
