module "networking" {
  source = "../../modules/networking"

  name_prefix        = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  az_count           = var.az_count
  enable_nat_gateway = true
  single_nat_gateway = false
  tags               = var.tags
}

module "eks" {
  source = "../../modules/eks"

  name_prefix             = var.project_name
  environment             = var.environment
  vpc_id                  = module.networking.vpc_id
  private_subnet_ids      = module.networking.private_subnet_ids
  kubernetes_version      = var.kubernetes_version
  endpoint_private_access = var.endpoint_private_access
  endpoint_public_access  = var.endpoint_public_access
  node_remote_access = try(var.jump_server.key_name, null) == null ? null : {
    ec2_ssh_key               = var.jump_server.key_name
    source_security_group_ids = [module.ec2_jump.security_group_id]
  }
  node_groups = var.node_groups
  tags        = var.tags
}

module "ec2_jump" {
  source = "../../modules/ec2"

  name_prefix                = var.project_name
  environment                = var.environment
  name_suffix                = "jump"
  vpc_id                     = module.networking.vpc_id
  subnet_id                  = module.networking.public_subnet_ids[0]
  instance_type              = var.jump_server.instance_type
  key_name                   = try(var.jump_server.key_name, null)
  allowed_cidr_blocks        = var.jump_server.allowed_cidr_blocks
  associate_public_ip_addess = var.jump_server.associate_public_ip_address
  ami_id                     = try(var.jump_server.ami_id, null)
  enable_ami_rotation        = try(var.jump_server.enable_ami_rotation, true)
  ami_rotation_days          = try(var.jump_server.ami_rotation_days, 90)
  root_volume_size           = var.jump_server.root_volume_size
  tags                       = var.tags
}

module "rds_secret" {
  source = "../../modules/secretsmanager"

  secret_name             = var.rds_secret.secret_name
  description             = "RDS credentials for ${var.project_name}-${var.environment}"
  username                = Var.rds_secret.username
  password_length         = var.rds_secret.password_length
  recovery_window_in_days = var.rds_secret.recovery_window_in_days
  tags                    = var.tags
}

module "rds" {
  source = "../../modules/rds"

  name_prefix                           = var.project_name
  environment                           = var.environment
  vpc_id                                = module.networking.vpc_id
  private_subnet_ids                    = module.networking.private_subnet_ids
  identifier_suffix                     = var.rds.identifier_suffix
  db_name                               = var.rds.db_name
  master_credentials_secret_arn         = module.rds_secret.secret_arn
  instance_class                        = var.rds.instance_class
  engine_version                        = var.rds.engine_version
  allocated_storage                     = var.rds.allocated_storage
  max_allocated_storage                 = var.rds.max_allocated_storage
  port                                  = var.rds.port
  multi_az                              = var.rds.multi_az
  backup_retention_period               = var.rds.backup_retention_period
  backup_window                         = var.rds.backup_window
  maintenance_window                    = var.rds.maintenance_window
  storage_encrypted                     = var.rds.storage_encrypted
  deletion_protection                   = var.rds.deletion_protection
  skip_final_snapshot                   = var.rds.skip_final_snapshot
  apply_immediately                     = var.rds.apply_immediately
  performace_insights_enabled           = var.rds.performance_insights_enabled
  performance_insights_retention_period = var.rds.performance_insights_retention_period
  allowed_security_group_ids            = concat([module.eks.node_security_group_id, module.ec2_jump.security_group_id], var.rds.allowed_security_group_ids)
  ingress_cidr_blocks                   = var.rds.ingress_cidr_blocks
  tags                                  = var.tags
}

module "s3" {
  source = "../../modules/s3"

  bucket_name        = var.s3.bucket_name
  force_destroy      = var.s3.force_destroy
  versioning_enabled = var.s3.versioning_enabled
  sse_algorithm      = var.s3.sse_algorithm
  tags               = var.tags
}
