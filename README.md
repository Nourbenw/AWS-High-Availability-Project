
# AWS High Availability Project

## 📋 Overview
This project demonstrates how to set up a **highly available environment** on AWS. It involves:
- Creating and configuring a **VPC** with subnets, route tables, and internet gateways.
- Setting up an **Application Load Balancer (ALB)** for traffic distribution.
- Configuring an **Auto Scaling Group (ASG)** for automatic scaling.
- Deploying a **Relational Database Service (RDS)** instance with Multi-AZ support.
- Ensuring high availability, fault tolerance, and scalability.

---

## 🛠️ AWS Services Used
- **Amazon VPC**: Network isolation and traffic control.
- **Elastic Load Balancer (ALB)**: Load distribution across instances.
- **Auto Scaling Group**: Dynamic resource scaling.
- **Amazon RDS**: Managed database services with high availability.
- **NAT Gateway**: For outbound internet access from private subnets.
- **AWS CLI**: Command-line interface for resource management.

---

## 📁 Project Structure
```plaintext
aws-high-availability-project/
│
├── scripts/
│   ├── vpc-setup.sh           # Script for creating VPC and subnets
│   ├── alb-setup.sh           # Script for setting up ALB
│   ├── asg-setup.sh           # Script for Auto Scaling
│
├── documentation/
│   ├── architecture-diagram.png # Architecture diagram
│   ├── commands.md              # Full list of AWS CLI commands
│
├── README.md                  # Project documentation
└── outputs/
    ├── test-results.txt       # Results of application tests
```

---

## 📝 Steps to Set Up the Project

### **Task 1: Inspecting the VPC**
1. **View VPC details**:
   ```bash
   aws ec2 describe-vpcs --output table
   ```
2. **Describe subnets in the VPC**:
   ```bash
   aws ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-0cfe31170e4dc9e43" --output table
   ```
3. **Query route tables**:
   ```bash
   aws ec2 describe-route-tables --filters "Name=vpc-id,Values=vpc-0cfe31170e4dc9e43" --query 'RouteTables[*].[RouteTableId, VpcId, Associations[*].SubnetId]'
   ```
4. **Describe internet gateways**:
   ```bash
   aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=vpc-0cfe31170e4dc9e43"
   ```
5. **View Network ACLs**:
   ```bash
   aws ec2 describe-network-acls --filters "Name=vpc-id,Values=vpc-0cfe31170e4dc9e43" --output table
   ```
6. **Describe security groups**:
   ```bash
   aws ec2 describe-security-groups --filters "Name=vpc-id,Values=vpc-0cfe31170e4dc9e43" --query 'SecurityGroups[*].[GroupId, GroupName]' --output table
   ```

### **Task 2: Configuring the Application Load Balancer**
1. **Create a security group for the load balancer**:
   ```bash
   aws ec2 create-security-group --group-name Inventory-LB --description "Enable web access to load balancer" --vpc-id vpc-0cfe31170e4dc9e43
   ```
2. **Set inbound rules for HTTP**:
   ```bash
   aws ec2 authorize-security-group-ingress --group-id <SecurityGroupID> --protocol tcp --port 80 --cidr 0.0.0.0/0
   ```
3. **Create the load balancer**:
   ```bash
   aws elbv2 create-load-balancer --name Inventory-LB --subnets subnet-0cdb0fefee3d033f2 subnet-0acf6d72db17f0373 --security-groups sg-01a9fe5c216e7c26a
   ```
4. **Create a target group**:
   ```bash
   aws elbv2 create-target-group --name Inventory-App --protocol HTTP --port 80 --vpc-id vpc-0cfe31170e4dc9e43
   ```
5. **Register instances with the target group**:
   ```bash
   aws elbv2 register-targets --target-group-arn <TargetGroupArn> --targets Id=<InstanceID>
   ```
6. **Create a listener**:
   ```bash
   aws elbv2 create-listener --load-balancer-arn <LoadBalancerArn> --protocol HTTP --port 80 --default-actions Type=forward,TargetGroupArn=<TargetGroupArn>
   ```

### **Task 3: Setting Up the Auto Scaling Group**
1. **Create an AMI**:
   ```bash
   aws ec2 create-image --instance-id <InstanceID> --name "Web Server AMI" --description "An AMI for my web server"
   ```
2. **Create the launch template**:
   ```bash
   aws ec2 create-launch-template --launch-template-name Inventory-LT --version-description "Web Server Template" --launch-template-data file://launch-template.json
   ```
3. **Create the Auto Scaling Group**:
   ```bash
   aws autoscaling create-auto-scaling-group --auto-scaling-group-name Inventory-ASG --launch-template "LaunchTemplateName=Inventory-LT" --min-size 2 --max-size 5 --vpc-zone-identifier "subnet-0cdb0fefee3d033f2,subnet-0acf6d72db17f0373"
   ```

### **Task 4: Configuring RDS for Multi-AZ**
1. **Modify RDS instance for Multi-AZ**:
   ```bash
   aws rds modify-db-instance --db-instance-identifier inventory-db --multi-az --apply-immediately
   ```

---

## 🚀 Testing
- **Access the application via the ALB DNS name**:
  ```bash
  aws elbv2 describe-load-balancers --names Inventory-LB --query 'LoadBalancers[*].DNSName'
  ```
- **Verify the status of targets**:
  ```bash
  aws elbv2 describe-target-health --target-group-arn <TargetGroupArn>
  ```

---

## 📊 Architecture Diagram
![Architecture Diagram](documentation/architecture-diagram.png)

---

## 🔗 Contact
For any questions or suggestions, feel free to contact me on GitHub.
```
