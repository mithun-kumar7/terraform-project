bucket         = "your-terraform-state-bucket"
key            = "eks/prod/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "your-terraform-lock-table"
encrypt        = true