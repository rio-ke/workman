
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
