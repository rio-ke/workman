## PCS cluster and its resources start up automatically after a server reboot


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
