#!/bin/bash
# AWS CLI Commands
# This command retrieves the details of all subnets associated with the specified VPC ID and displays them in a table format.
aws ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-0cfe31170e4dc9e43" --output table

# This command retrieves information about the route tables in the specified VPC, including their IDs and associated subnets.
aws ec2 describe-route-tables --filters "Name=vpc-id,Values=vpc-0cfe31170e4dc9e43" --query 'RouteTables[*].[RouteTableId, VpcId, Associations[*].SubnetId]'

# This command lists all internet gateways attached to the specified VPC.
aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=vpc-0cfe31170e4dc9e43"

# This command retrieves and displays the network access control lists (ACLs) for the specified VPC.
aws ec2 describe-network-acls --filters "Name=vpc-id,Values=vpc-0cfe31170e4dc9e43" --output table

# This command creates a new security group named 'Inventory-LB' with a description, associated with the specified VPC.
aws ec2 create-security-group --group-name Inventory-LB --description "Enable web access to load balancer" --vpc-id vpc-0cfe31170e4dc9e43

# This command allows inbound HTTP traffic on port 80 for the specified security group.
aws ec2 authorize-security-group-ingress --group-id <SecurityGroupID> --protocol tcp --port 80 --cidr 0.0.0.0/0

# This command creates a new load balancer named 'Inventory-LB' in the specified subnets and security group.
aws elbv2 create-load-balancer --name Inventory-LB --subnets subnet-0cdb0fefee3d033f2 subnet-0acf6d72db17f0373--security-groups sg-01a9fe5c216e7c26a

# This command creates a target group named 'Inventory-App' that will route HTTP traffic to instances in the specified VPC.
aws elbv2 create-target-group --name Inventory-App --protocol HTTP --port 80 --vpc-id vpc-0cfe31170e4dc9e43

# This command registers an EC2 instance with the specified ID as a target for the target group.
aws elbv2 register-targets --target-group-arn arn:aws:elasticloadbalancing:us-east-1:667166769231:targetgroup/Inventory-App/d40bcb60cdf1d992 --targets Id=i-0d43795bc7c648c42
# This command creates a listener for the load balancer that forwards HTTP traffic to the specified target group.
aws elbv2 create-listener --load-balancer-arn arn:aws:elasticloadbalancing:us-east-1:667166766667:loadbalancer/Inventory-LB --protocol HTTP --port 80 --default-actions Type=forward,TargetGroupArn=arn:aws:elasticloadbalancing:us-east-1:667166766667:targetgroup/Inventory-App/<unique-id>

# This command creates an auto-scaling group named 'Inventory-ASG' with specified minimum, maximum, and desired capacity.
# This command attaches the specified target group to the auto-scaling group.

# This command attaches the specified target group to the auto-scaling group.
aws autoscaling attach-load-balancer-target-groups --auto-scaling-group-name Inventory-ASG --target-group-arn arn:aws:elasticloadbalancing:us-east-1:667166766667:targetgroup/Inventory-App/<unique-id>

# This command creates an AMI from the specified EC2 instance.
aws ec2 create-image --instance-id <InstanceID> --name "Web Server AMI" --description "An AMI for my web server"

# This command creates a launch template named 'Inventory-LT' with specified instance type.
aws ec2 create-launch-template --launch-template-name Inventory-LT --version-description "Version 1" --launch-template-data '{"instanceType":"t2.micro"}'

# This command modifies the RDS instance to enable Multi-AZ deployment immediately.
aws rds modify-db-instance --db-instance-identifier inventory-db --multi-az --apply-immediately

# This command creates a NAT gateway in the specified subnet with the specified Elastic IP allocation ID.
aws ec2 create-nat-gateway --subnet-id subnet-0acf6d72db17f0373 --allocation-id eipalloc-12345678

# This command lists all EC2 instances with their IDs, states, and names.
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId, State.Name, Tags[?Key==`Name`].Value | [0]]'

# This command terminates the specified EC2 instance.
aws ec2 terminate-instances --instance-ids i-0d43795bc7c648c42

