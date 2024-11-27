# AWS-High-Availability-Project
AWS High Availability Project A practical implementation of a highly available environment on AWS. It includes setting up a VPC, Application Load Balancer, Auto Scaling Group, and Amazon RDS with Multi-AZ deployment, ensuring fault tolerance and scalability.

# AWS High Availability Project

## 📋 Overview
This project is a practical implementation of creating a **highly available environment** on AWS. It includes:
- Setting up a **VPC** and associated networking components.
- Configuring an **Application Load Balancer** (ALB).
- Creating an **Auto Scaling Group**.
- Configuring **Amazon RDS** with Multi-AZ deployment.
- Setting up routing, security, and failover mechanisms.

The goal is to achieve fault tolerance, scalability, and high availability.

---

## 🛠️ AWS Services Used
- **Amazon VPC**: For networking and isolation.
- **Elastic Load Balancer (ALB)**: For distributing traffic across instances.
- **Auto Scaling Group**: For dynamic scaling of resources.
- **Amazon RDS**: For database management.
- **NAT Gateway**: For internet access in private subnets.
- **AWS CLI**: For managing resources programmatically.

---

## 📁 Project Structure
```plaintext
project-folder/
│
├── scripts/
│   ├── vpc-setup.sh           # Script for creating VPC and subnets
│   ├── alb-setup.sh           # Script for setting up ALB
│   ├── asg-setup.sh           # Script for Auto Scaling
│
├── documentation/
│   ├── architecture-diagram.png # Architecture diagram
│   ├── commands.md              # List of AWS CLI commands
│
├── README.md                  # Project documentation
└── outputs/
    ├── test-results.txt       # Results of application tests
