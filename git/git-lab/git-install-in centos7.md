http://thealarmclocksixam.wordpress.com/2013/01/06/git-repo-tutoria/
http://www.saintsjd.com/2011/01/what-is-a-bare-git-repository/
http://git-scm.com/book/en/Git-on-the-Server-Setting-Up-the-Server


# SSH Server configuration

The machine that will host the git repository needs to be accessed by clients. A possible way to access a machine remotely is through SSH.
SSH supports both password and public/private keys authentication. In this tutorial I will use RSA keys.

Install and configure an SSH server on the machine that will host the git repository:

yum install -y openssh-server


Edit the /etc/ssh/sshd_config file to tweak the SSH server settings at your preference. I generally disable Password Authentication (you may need to uncomment the line) and Challenge Response Authentication:

# Change to yes to enable challenge-response passwords (beware issues with
# some PAM modules and threads)
ChallengeResponseAuthentication no
# Change to no to disable tunnelled clear text passwords
PasswordAuthentication no


Start or restart the ssh daemon to accept the new configuration:

cd /etc/init.d/
service sshd restart


Authorized Keys configuration

The public keys of the authorized entities who can login through ssh must be collected in the authorized_keys file under the ~/.ssh folder.


# Adding a user to install/administer the private git server

adduser git   # create user git
passwd git    # change passwd

sudo su git  # switch as git user


# Installing git

sudo yum install -y git


# Create a .ssh folder in home directory and set its permissions (see the ssh man (1) page for explanations on permissions of the .ssh folder and its content):

mkdir .ssh
chmod 700 .ssh

Create an authorized_keys file under the ~/.ssh folder and append to it the public keys of the authorized git users:

vi .ssh/authorized_keys

Set the proper permissions for the authorized_keys file:

chmod 600 .ssh/authorized_keys

```bash

[git@ip-xxxxx test]$ ssh-keygen -t rsa -C "Comment Here bhalothia@gmail.com"
Generating public/private rsa key pair.
Enter file in which to save the key (/home/git/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/git/.ssh/id_rsa.
Your public key has been saved in /home/git/.ssh/id_rsa.pub.
The key fingerprint is:
7d:21:bf:11:eb:7d:a1:52:1d:0e:c1:8c:d0:7f:5c:f7 Comment Here bhalothia@gmail.com
The key's randomart image is:
+--[ RSA 2048]----+
|         .o +.   |
|           o o. o|
|          . +...+|
|         . o =+oE|
|        S . =..+ |
|           o.+. .|
|           .o.. .|
|            .  . |
|                 |
+-----------------+
```
# Appending publick key to authorized_keys file
A possible way to populate the authorized_keys file, from a user on the same machine as the “git” user would be (appends the public key of the current user at the end of the authorized_keys file of the “git” user, command issued from the home directory):

sudo bash -c "cat .ssh/id_rsa.pub >> ../git/.ssh/authorized_keys"



# Creating and initializing a bare git repo

cd /opt/git
mkdir project.git
cd project.git
git --bare init

## The server configuration is done.


## Client configuration:


P The remaining part of the tutorial refers to operations to be done on the client who wants to access the git repository that we have prepared. In order to use the Secure SHell connection, the client needs a pair of public/private keys.


```bash
[client@ip-xxxxx test]$ ssh-keygen -t rsa -C "bhalothia@gmail.com"
Generating public/private rsa key pair.
Enter file in which to save the key (/home/jboss/.ssh/id_rsa): 
Created directory '/home/jboss/.ssh'.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/jboss/.ssh/id_rsa.
Your public key has been saved in /home/jboss/.ssh/id_rsa.pub.
The key fingerprint is:
0e:2f:97:19:bd:d4:90:72:be:5e:95:b6:c6:76:1e:f6 bhalothia@gmail.com
The key's randomart image is:
+--[ RSA 2048]----+
|                 |
|           .     |
|        . +      |
|         = o   . |
|      . S + . +  |
|       + = o + . |
|      . * o . =o.|
|       o . . o.oo|
|          .     E|
+-----------------+
```
* Append .ssh/id_rsa.pub of client's to Server's .ssh/authorized_keys

* On client machine:

cd myproject
git init
git add .
git commit -m 'initial commit'
git remote add origin git@gitserver:/opt/git/project.git   
git push origin master

* At this point, the others can clone it down and push changes back up just as easily:

git clone git@gitserver:/opt/git/project.git
cd project
vim README
git commit -am 'fix for the README file'
git push origin master

* With this method, you can quickly get a read/write Git server up and running for a handful of developers.
