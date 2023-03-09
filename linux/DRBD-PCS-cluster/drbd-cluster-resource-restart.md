## PCS cluster and its resources start up automatically after a server reboot

Configuring a PCS cluster and its resources to start up automatically after a server reboot involves several steps. Here is a detailed guide on how to do it:

    Configure the PCS cluster and its resources to start automatically by setting the "Start" property to "true" in the cluster configuration file. The cluster configuration file is usually located at /etc/corosync/corosync.conf or /etc/pacemaker/crm.conf. You can edit this file with a text editor like vi or nano.

    Locate the primitive section of the cluster configuration file where you define the resources you want to manage. For example, if you have a resource named "webserver" defined, you should see a section like this:

    csharp

primitive webserver ocf:heartbeat:apache \
   params configfile="/etc/httpd/conf/httpd.conf" \
   op monitor interval="15s"

Add the following line to the resource definition to make it start automatically:

python

meta target-role="Started"

The resource definition should now look like this:

csharp

primitive webserver ocf:heartbeat:apache \
   params configfile="/etc/httpd/conf/httpd.conf" \
   op monitor interval="15s" \
   meta target-role="Started"

Configure the Corosync service to start automatically by adding it to the startup scripts or enabling it as a systemd service.

To enable Corosync as a systemd service, run the following command:

bash

systemctl enable corosync.service

Configure the Pacemaker service to start automatically by adding it to the startup scripts or enabling it as a systemd service.

To enable Pacemaker as a systemd service, run the following command:

bash

systemctl enable pacemaker.service

Ensure that any dependencies or prerequisites for the PCS cluster and its resources are met, such as network connectivity, storage availability, and authentication.

For example, if your PCS cluster relies on a shared storage device, ensure that the storage device is mounted and accessible before the cluster starts.

Test the automatic startup of the PCS cluster and its resources by rebooting the server and verifying that the cluster and its resources are running as expected.

After the server has rebooted, you can check the status of the PCS cluster and its resources by running the following command:

lua

    pcs status

    This command will show you the current status of the PCS cluster and its resources. If everything is working as expected, you should see all the resources in the "Started" state.

By following these steps, you should be able to configure a PCS cluster and its resources to start up automatically after a server reboot.


$$next-step$$


* To ensure that your PCS cluster and its resources start up automatically after a server reboot, you can use the following steps:

    First, you'll need to ensure that the PCS service is set to start automatically on server boot. You can do this by running the following command:

```bash

sudo systemctl enable pcsd.service
```

* Once you have enabled the PCS service, you can create a cluster and configure its resources. You can use the pcs command-line tool to manage the cluster and its resources. For example, to create a new cluster, you can run the following command:

```cmd

sudo pcs cluster setup --name mycluster node1 node2
```

* This command will create a new cluster named mycluster with two nodes, node1 and node2.

* After you have created the cluster, you can configure its resources using the pcs command-line tool. For example, to create a resource for a PostgreSQL database, you can run the following command:

```sql

sudo pcs resource create pgsql-ha ocf:heartbeat:pgsql \
  dbname=mydatabase user=myuser password=mypassword \
  op monitor interval=30s
```

* This command will create a new resource named pgsql-ha for a PostgreSQL database. It will monitor the database every 30 seconds to ensure that it is running correctly.

* Once you have configured the resources for your cluster, you can save the configuration and start the cluster. You can use the following commands to do this:

```sql
sudo pcs cluster cib mycluster_cfg
sudo pcs cluster verify mycluster_cfg
sudo pcs cluster start --all
sudo pcs cluster enable --all
```
    
* These commands will create a new configuration for your cluster, verify that the configuration is valid, start the cluster, and enable all resources in the cluster.

* After you have completed these steps, your PCS cluster and its resources will start up automatically whenever the server reboots. If you encounter any issues, you can check the logs for the PCS service and its resources to troubleshoot the problem.
