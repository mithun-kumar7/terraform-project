# EKS Terraform Workspace

This workspace creates AWS networking and EKS infrastructure using reusable Terraform modules.

## What this builds

- 1 VPC
- 2 public subnets and 2 private subnets across 2 Availability Zones
- Internet Gateway, NAT Gateway, and route tables
- EKS cluster
- EKS managed node groups in private subnets only
- PostgreSQL RDS instance in private subnets
- RDS credentials generated and stored in AWS Secret Manager
- S3 bucket with public access blocked
- EC2 jump server for private access to nodes and RDS
- ECR repositories for storing Docker images
- IAM roles and security groups required for EKS and worker nodes

## Structure

```text
.
├── modules
│   ├── networking
│   ├── eks
│   ├── rds
│   ├── secretsmanager
│   ├── s3
│   ├── ecr
│   └── ec2
└── environments
    ├── dev
    └── prod
```

## Usage

1. Set AWS credentials for your account.
2. Change into one environment folder.
3. Update backend settings in `backend.hcl` for your bucket and lock table.
4. Initialize, plan, and apply.

### Dev

```bash
cd environments/dev
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

### Prod

```bash
cd environments/prod
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

## Notes

- Worker nodes are launched only in private subnets (`private_subnet_ids`).
- RDS is provisioned in private subnets through an RDS subnet group and is not publicly accessible.
- RDS username/password are no longer stored in tfvars; credentials are generated in `modules/secretsmanager`, stored in AWS Secret Manager, and fetched by the RDS module.
- The S3 module creates a private bucket with all public access blocked, bucket ownership enforced, versioning enabled by default, and SSE enabled.
- The EC2 jump server is deployed in a public subnet, allow SSH only from configured CIDRs, and is allowed to access both EKS nodes (SSH) and PostgreSQL RDS.
- The jump server supports compliance-oriented AMI refresh by forcing instance replacement every 90 days by default (`jump_server.enable_ami_rotation` and `jump_server.ami_rotation_days`).
- Set jump_server.key_name in each environment tfvars so EKS managed node groups enable remote access using the same key and jump-server security group.
- Adjust CIDRs, node groups, and endpoint access in each environment's `terraform.tfvars`.
- S3 backend is configured in each environment's `versions.tf`, and concrete values are in each `backend.hcl`.
- For multi-account setups, set `aws_profile` and `allowed_account_ids` per environment to prevent accidental deployment to the wrong AWS account.
- The ECR module creates one repositories per entry in `ecr_repositories`. Each repository has image scanning on push enabled and an automatic lifecycle policy that retains the last N tagged images and expires untagged images after 7 days. EKS worker nodes already have `AmazonEC2ConatinerRegistryReadOnly` attached and can pull images without further configuration.
- To push Docker images, authenticate with:
  ```bash
  aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account_id>.dkr.ecr.<region>.amazonaws.com
  ```
