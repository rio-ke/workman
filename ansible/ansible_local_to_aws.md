**_Local to aws_**

https://medium.com/@a_tsai5/creating-an-ec2-instance-using-ansible-764cf70015f6

`way_two:`

_Generate the SSH Key Pair on Local linux machine_

```cmd
ssh-keygen -t rsa -b 2048
```
_go to ec2-instance key dir_

```cmd
cd aws-key/
```
* copy newly created `ken.pem.pub` to aws instance
```cmd
scp -i virginia_key.pem -r ~/.ssh/ansible-key.pem.pub ubuntu@public_key:~/.ssh
```
_create the ~/.ssh/authorized_keys file if not_
```cmd
touch ~/.ssh/authorized_keys
```
_Manually Add Key_
```cmd
cat ~/.ssh/ansible-key.pem.pub >> ~/.ssh/authorized_keys
```
_file permissions_
```cmd
chmod 600 ~/.ssh/authorized_keys
```
_Check EC2 Instance Connection_
* Ensure that your EC2 instance is accessible and that you can connect to it using the specified private key manually
```cmd
ssh -i ~/.ssh/ansible-key.pem ubuntu@public_ip
```
```hosts
[web_servers]
ec2_instance ansible_ssh_host=your_ec2_instance_ip ansible_ssh_user=ec2-user ansible_ssh_private_key_file=/path/to/your/private-key.pem
```
 
