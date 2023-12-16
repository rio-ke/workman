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
