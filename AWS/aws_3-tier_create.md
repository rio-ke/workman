
![image](https://github.com/rio-ke/workman/assets/88568938/92b6bb1f-f8b8-4e35-9576-f3a90fc0f85e)

* create vpc
* create 2 public subnets
* create 4 private subnets
* create 1 pub route table
* create 2 private route table
   
    - A VPC.
       - Two (2) public subnets spread across two availability zones (Web Tier).
       - Two (2) private subnets spread across two availability zones (Application Tier).
       - Two (2) private subnets spread across two availability zones (Database Tier).
       - One (1) public route table that connects the public subnets to an internet gateway.
       - One (1) private route table that will connect the Application Tier private subnets and a NAT gateway.

![image](https://github.com/rio-ke/workman/assets/88568938/64e899a3-c1c0-444e-bd89-fc50c9ac2f10)

* Enable auto-assign IPv4
    - Once all the assets have been created, we need to make sure we ‘Enable auto-assign public IPv4 address’ for BOTH public subnets so we can access its resources via the Internet.
 
* Set main route table
    - When a VPC is created, it comes with a default route table as its ‘main table.’ However, we want our public-rtb to serve as the main table, so select the public-rtb from the ‘Route tables’ dashboard and set it as the main table under the ‘Actions’ dropdown menu.

* Create a NAT Gateway (public)

![image](https://github.com/rio-ke/workman/assets/88568938/92a1b7e6-872a-4854-a34a-eee361d080d7)

* _Configure private route tables_
    - create one route table for private subnet
    - we can associate this table with all four private subnets (-subnet-private1, -subnet-private2, -subnet-private-3, -subnet-private4)
     ![image](https://github.com/rio-ke/workman/assets/88568938/a5c97b4d-429c-423b-944c-f41ac7bcd484)

    - add a new route to our NAT gateway
    ![image](https://github.com/rio-ke/workman/assets/88568938/868b976c-9990-49f1-a1ba-cb33831ac815)
    ![image](https://github.com/rio-ke/workman/assets/88568938/da810a5b-1bfe-42a4-9106-fea206e2f9b7)
----

_**Tier 1: Web tier**_

1. A web server launch template to define what kind of EC2 instances will be provisioned for the application.
2. An Auto Scaling Group (ASG) that will dynamically provision EC2 instances.
3. An Application Load Balancer (ALB) to help route incoming traffic to the proper targets.

![image](https://github.com/rio-ke/workman/assets/88568938/61512a0a-abba-4472-a863-60ad995be2e4)

* EC2 
   - Lanch EC2 instance
   - Create webserver security group to allow 22,80,443
 
 * Application load balancer (ALB)
    * We’ll need an ALB to distribute incoming HTTP traffic to the proper targets (our EC2s). The ALB will be named, ‘webServer-alb.’ We want this ALB to be ‘Internet-facing,’ so it can listen for HTTP/S requests
 ![image](https://github.com/rio-ke/workman/assets/88568938/161a8247-7ec5-436c-a292-32d5581452b3)

    * Creating an ALB From the ASG interface automatically attaches the default security group to our ALB. We need the webServer-sg, so after the ASG is complete, we need to go back to the load balancer and make sure the proper security group is attached.
    * The ALB needs to ‘listen’ over HTTP on port 80 and a target group that routes to our EC2 instances.
    * Create target group for alb and then add two pub subnet
      
 ![image](https://github.com/rio-ke/workman/assets/88568938/2447d661-0905-4d28-a785-cdaa0f9d6a9f)
 ![image](https://github.com/rio-ke/workman/assets/88568938/d69219d3-de55-4b61-a548-847a88e0c35c)
      
 ![image](https://github.com/rio-ke/workman/assets/88568938/8d578567-f8a7-462e-a90d-3e779c8c6cf1)

* SSH
    - Test ssh into the webservers




**_Tier 3- Database tier_**


* A database security group that allows outbound and inbound mySQL requests to and from our app servers.
* A DB subnet group to ensure the database is created in the proper subnets.
* An RDS database with MySql.

* Create a database security group

  - Our application servers need a way to access the database, so let’s first create a security group that allows inbound traffic from the application servers.

![image](https://github.com/rio-ke/workman/assets/88568938/7009bbf6-6046-48ba-b768-304b14edd17e)

  - we need to add inbound AND outbound rules that allow MySQL requests to and from the application servers on port 3306.

![image](https://github.com/rio-ke/workman/assets/88568938/6172cf00-b77d-4cf2-a28c-071d40f9582c)
![image](https://github.com/rio-ke/workman/assets/88568938/8cfd77a7-92ec-431f-89b9-9c8f9fbd0206)

  - We’ll need to do the same for the brainiac-appServer-sg.

![image](https://github.com/rio-ke/workman/assets/88568938/fb2117f0-9cdc-4ab9-a6a8-3d919460c1bc)
![image](https://github.com/rio-ke/workman/assets/88568938/c6f7941b-ec0a-4ac5-a22e-2d6151ab5dbd)

* Create a DB subnet group

  
