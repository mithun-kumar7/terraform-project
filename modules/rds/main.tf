data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = var.master_credentials_secret_arn
}

locals {
  db_credentials = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-${var.environment}-${var.identifier_suffix}-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-${var.identifier_suffix}-subnet-group"
  })
}

resource "aws_security_group" "this" {
  name        = "${var.name_prefix}-${var.environment}-${var.identifier_suffix}-sg"
  description = "Security group for PostgreSQL RDS."
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-${var.identifier_suffix}-sg"
  })
}

resource "aws_security_group_rule" "ingress_sg" {
  for_each = toset(var.allowed_security_group_ids)

  type                     = "ingress"
  from_port                = var.port
  to_port                  = var.port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.this.id
  source_security_group_id = each.value
  description              = "Postgres access from trusted security group."
}

resource "aws_security_group_rule" "ingress_cidr" {
  for_each = toset(var.ingress_cidr_blocks)

  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  security_group_id = aws_security_group.this.id
  cidr_blocks       = [each.value]
  description       = "PostgreSQL access from trusted CIDR"
}

resource "aws_db_instance" "this" {
  identifier                            = "${var.name_prefix}-${var.environment}-${var.identifier_suffix}"
  engine                                = "postgres"
  engine_version                        = var.engine_version
  instance_class                        = var.instance_class
  allocated_storage                     = var.allocated_storage
  max_allocated_storage                 = var.max_allocated_storage
  db_name                               = var.db_name
  username                              = local.db_credentials[var.secret_username_key]
  password                              = local.db_credentials[var.secret_passowrd_key]
  port                                  = var.port
  db_subnet_group_name                  = aws_db_subnet_group.this.name
  vpc_security_group_ids                = [aws_security_group.this.id]
  publicly_accessible                   = false
  multi_az                              = var.multi_az
  backup_retention_period               = var.backup_retention_period
  backup_window                         = var.backup_window
  maintenance_window                    = var.maintenance_window
  storage_encrypted                     = var.storage_encrypted
  skip_final_snapshot                   = var.skip_final_snapshot
  deletion_protection                   = var.deletion_protection
  apply_immediately                     = var.apply_immediately
  auto_minor_version_upgrade            = true
  copy_tags_to_snapshot                 = true
  performance_insights_enabled          = var.performace_insights_enabled
  performance_insights_retention_period = var.performace_insights_enabled ? var.performance_insights_retention_period : null

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-${var.identifier_suffix}"
  })
}


