project_name            = "sample-eks"
environment             = "dev"
aws_region              = "us-east-1"
aws_profile             = "dev"
allowed_account_ids     = ["111111111111"]
vpc_cidr                = "10.20.0.0/16"
az_count                = 2
kubernetes_version      = "1.31"
endpoint_private_access = true
endpoint_public_access  = false

node_groups = {
  general = {
    desired_size   = 2
    min_size       = 1
    max_size       = 3
    instance_types = ["t3.medium"]
    capacity_type  = "ON_DEMAND"
    disk_size      = 30
    labels = {
      workload = "general"
    }
  }
}

rds = {
  identifier_suffix                     = "postgres"
  db_name                               = "appdb"
  instance_class                        = "db.t4g.medium"
  engine_version                        = "16.3"
  allocated_storage                     = 100
  max_allocated_storage                 = 200
  port                                  = 5432
  multi_az                              = false
  backup_retention_period               = 7
  backup_window                         = "03:00-04:00"
  maintenance_window                    = "sun:04:00-sun:05:00"
  storage_encrypted                     = true
  deletion_protection                   = false
  skip_final_snapshot                   = true
  apply_immediately                     = false
  performace_insights_enabled           = false
  performance_insights_retention_period = 7
  allowed_security_group_ids            = []
  ingress_cidr_blocks                   = []
}

rds_secret = {
  secret_name             = "sample-eks-dev-rds-credentials"
  username                = "dbadmin"
  password_length         = 24
  recovery_window_in_days = 7
}

s3 = {
  bucket_name        = "sample-eks-dev-app-bucket-123456"
  force_destroy      = false
  versioning_enabled = true
  sse_algorithm      = "AES256"
}

jump_server = {
  instance_type              = "t3.micro"
  key_name                   = "your-dev-keypair-name"
  allowed_cidr_blocks        = ["203.0.113.10/32"]
  associate_public_ip_addess = true
  enable_ami_rotation        = true
  ami_rotation_days          = 90
  root_volume_size           = 20
}

tags = {
  Owner       = "platform-team"
  CostCenter  = "devops"
  Environment = "dev"
}
