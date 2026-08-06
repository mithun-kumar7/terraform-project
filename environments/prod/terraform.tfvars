project_name            = "sample-eks"
environment             = "prod"
aws_region              = "us-east-1"
aws_profile             = "prod"
allowed_account_ids     = ["22222222222"]
vpc_cidr                = "10.30.0.0/16"
az_count                = 2
kubernetes_version      = "1.31"
endpoint_private_access = true
endpoint_public_access  = false

node_groups = {
  general = {
    desired_size   = 3
    min_size       = 2
    max_size       = 6
    instance_types = ["m5.large"]
    capacity_type  = "ON_DEMAND"
    disk_size      = 50
    labels = {
      workload = "general"
      tier     = "prod"
    }
  }

  spot = {
    desired_size   = 2
    min_size       = 1
    max_size       = 5
    instance_types = ["m5.large", "m5a.large"]
    capacity_type  = "SPOT"
    disk_size      = 50
    labels = {
      workload = "batch"
      tier     = "prod"
    }
  }
}

rds = {
  identifier_suffix                     = "postgres"
  db_name                               = "appdb"
  instance_class                        = "db.m6g.large"
  engine_version                        = "16.3"
  allocated_storage                     = 200
  max_allocated_storage                 = 500
  port                                  = 5432
  multi_az                              = true
  backup_retention_period               = 14
  backup_window                         = "02:00-03:00"
  maintenance_window                    = "sun:03:00-sun:04:00"
  storage_encrypted                     = true
  deletion_protection                   = true
  skip_final_snapshot                   = false
  apply_immediately                     = false
  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  allowed_security_group_ids            = []
  ingress_cidr_blocks                   = []
}

rds_secret = {
  secret_name             = "sample-eks-prod-rds-credentials"
  username                = "dbadmin"
  password_length         = 24
  recovery_window_in_days = 7
}

s3 = {
  bucket_name        = "sample-eks-prod-app-bucket-123456"
  force_destroy      = false
  versioning_enabled = true
  sse_algorithm      = "AES256"
}

jump_server = {
  instance_type               = "t3.micro"
  key_name                    = "your-prod-keypair-name"
  allowed_cidr_blocks         = ["203.0.113.10/32"]
  associate_public_ip_address = true
  enable_ami_rotation         = true
  ami_rotation_days           = 90
  root_volume_size            = 20
}

tags = {
  Owner       = "platform-team"
  CostCenter  = "devops"
  Environment = "prod"
}
