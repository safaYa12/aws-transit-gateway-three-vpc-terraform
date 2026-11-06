# AWS Transit Gateway – Three VPC Architecture with Terraform

A hands-on AWS networking and cloud security project demonstrating a centralized multi-VPC architecture using **AWS Transit Gateway**, provisioned through Terraform.

The project is designed to connect three independent Amazon VPCs through a centralized Transit Gateway while incorporating network traffic visibility using VPC Flow Logs and Amazon CloudWatch.

## Architecture Overview

The architecture consists of three VPCs connected through AWS Transit Gateway.

| Component | Purpose | CIDR |
|---|---|---|
| VPC-A | Application | `10.0.0.0/16` |
| VPC-B | Backend | `10.1.0.0/16` |
| VPC-C | Security & Monitoring | `10.2.0.0/16` |

### Architecture Design

```text
                     AWS Cloud
                         |
                AWS Transit Gateway
                         |
          +--------------+--------------+
          |              |              |
          |              |              |
     VPC-A             VPC-B          VPC-C
   Application         Backend      Security &
   10.0.0.0/16       10.1.0.0/16   Monitoring
                                      10.2.0.0/16
       |                 |              |
    EC2 Instance      EC2 Instance   EC2 Instance
       |                 |              |
       +-----------------+--------------+
                         |
                  Centralized Network
                    Connectivity

             VPC Flow Logs enabled
                         |
                  Amazon CloudWatch
                   Log Group
```

## Technologies Used

- **AWS Networking**
  - Amazon VPC
  - AWS Transit Gateway
  - Transit Gateway VPC Attachments
  - Transit Gateway Route Tables
  - VPC Route Tables
  - Internet Gateways
  - Security Groups
- **AWS Security & Monitoring**
  - VPC Flow Logs
  - Amazon CloudWatch Logs
  - AWS IAM Roles and Policies
- **Infrastructure as Code**
  - Terraform
  - AWS CLI
- **Version Control**
  - Git
  - GitHub

## Project Structure

```text
aws-transit-gateway-three-vpc/
│
├── provider.tf
├── main.tf
├── variable.tf
├── terraform.tfvars.example
├── networking.tf
├── security.tf
├── compute.tf
├── transit_gateway.tf
├── monitoring.tf
├── output.tf
├── .gitignore
├── .terraform.lock.hcl
└── README.md
```

## Key Implementation Details

### 1. Multi-VPC Architecture

Created three separate VPCs with non-overlapping CIDR ranges:

- Application VPC: `10.0.0.0/16`
- Backend VPC: `10.1.0.0/16`
- Security VPC: `10.2.0.0/16`

This provides separate network environments for application workloads, backend services, and security monitoring.

### 2. AWS Transit Gateway

Designed a centralized network connectivity architecture using AWS Transit Gateway.

The Transit Gateway acts as a hub connecting all three VPCs through dedicated VPC attachments.

Key configuration areas:

- Transit Gateway creation
- VPC attachments
- Transit Gateway route tables
- Route table associations
- Explicit network routing

### 3. Network Routing

Configured VPC route tables to direct traffic destined for other VPC CIDR ranges through the Transit Gateway.

The architecture uses explicit routing to control communication between the connected VPCs.

### 4. Security Groups

Implemented security group rules to control communication between workloads.

The configuration includes:

- SSH access restricted to the configured administrator CIDR.
- ICMP traffic for network connectivity testing.
- HTTP access for application testing.
- Outbound traffic rules.

### 5. VPC Flow Logs

Enabled VPC Flow Logs for all three VPCs to capture network traffic information.

Flow Logs provide visibility into network traffic and help support network troubleshooting and security analysis.

### 6. Centralized CloudWatch Logging

Configured Amazon CloudWatch Logs as the destination for VPC Flow Logs.

The implementation includes:

- CloudWatch Log Group
- IAM Role for VPC Flow Logs
- IAM permissions for log delivery
- Flow Log resources for all three VPCs

This provides a centralized location for network traffic visibility.

### 7. EC2 Instances

Provisioned Amazon Linux 2023 EC2 instances in each VPC.

Apache HTTP Server is configured through instance user data to provide a basic application endpoint for network connectivity testing.

## Deployment Guide

### Prerequisites

Install and configure:

- Terraform
- AWS CLI
- Git
- An AWS account with the required permissions

### Step 1: Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/aws-transit-gateway-three-vpc.git
cd aws-transit-gateway-three-vpc
```

### Step 2: Configure AWS Credentials

```bash
aws configure --profile terraform-user
```

Verify the AWS identity:

```bash
aws sts get-caller-identity --profile terraform-user
```

### Step 3: Configure Terraform Variables

Create your local variable file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Update the values according to your environment.

### Step 4: Initialize Terraform

```bash
terraform init
```

### Step 5: Validate Configuration

```bash
terraform validate
```

### Step 6: Review the Execution Plan

```bash
terraform plan
```

### Step 7: Deploy Infrastructure

```bash
terraform apply
```

Review the execution plan and confirm when prompted.

### Step 8: View Terraform Outputs

```bash
terraform output
```

## Security Considerations

- Use least-privilege IAM permissions.
- Restrict SSH access to trusted administrator IP addresses.
- Apply appropriate security group rules.
- Avoid exposing private workloads directly to the internet.
- Never commit AWS credentials, private keys, Terraform state files, or sensitive configuration.
- Review Terraform plans before applying changes.
- Monitor AWS resource usage and associated costs.

## AWS Networking Concepts Demonstrated

- Centralized connectivity using AWS Transit Gateway.
- Multi-VPC network architecture.
- VPC attachments and routing.
- Transit Gateway route table associations.
- Network segmentation concepts.
- VPC Flow Logs for network visibility.
- Centralized logging using CloudWatch.
- Infrastructure provisioning through Terraform.

## Future Enhancements

Potential extensions include:

- Dedicated Transit Gateway route tables for network segmentation.
- Centralized inspection using AWS Network Firewall.
- Integration with AWS Security Hub.
- Security analytics using Amazon Athena.
- Automated network traffic analysis.
- Centralized security monitoring and alerting.

## Cleanup

To remove Terraform-managed infrastructure:

```bash
terraform destroy
```

Review the destruction plan before confirming.

## Author

**Muhammed Safayath T.**

Cloud Security | AWS | Cybersecurity | Infrastructure as Code

GitHub: [@safaYa12](https://github.com/safaYa12)

---

*This project explores centralized AWS network connectivity and network security visibility through practical implementation using Terraform.*
