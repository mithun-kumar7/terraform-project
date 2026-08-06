data "aws_ssm_parameter" "al2023" {
  name = var.ami_ssm_parameter_name
}

locals {
  selected_ami_id = var.ami_id != null ? var.ami_id : data.aws_ssm_parameter.al2023.value
}

resource "time_rotating" "ami_rotation" {
  count = var.enable_ami_rotation ? 1 : 0

  rotation_days = var.ami_rotation_days
}

resource "aws_security_group" "this" {
  name        = "${var.name_prefix}-${var.environment}-${var.name_suffix}-sg"
  description = "security group for EC2 jump server"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    content {
      description = "SSH access to jump server"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-${var.name_suffix}-sg"
  })
}

resource "aws_instance" "this" {
  ami                         = local.selected_ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.this.id]
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip_addess

  user_data = var.user_data

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
    encrypted   = true
  }

  lifecycle {
    replace_triggered_by = var.enable_ami_rotation ? [time_rotating.ami_rotation[0].id] : []
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-${var.name_suffix}"
  })
}
