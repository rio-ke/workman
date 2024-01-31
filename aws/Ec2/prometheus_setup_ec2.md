* Create VPC, public-subnet, route-table, igw

 * Create security group
    * Prometheus 9090,
    * Node exporter 9100,
    * Alert manager 3000,
![Image](https://github.com/januo-org/proof-of-concepts/assets/88568938/1b3cff16-e472-4fe3-8dff-89d4dc445582)

* create ec2 instance for prometheus service

   * first login to ec2 server with ssh 
  
```cmd
ssh -i virginia_key.pem ubuntu@public-ip
```
