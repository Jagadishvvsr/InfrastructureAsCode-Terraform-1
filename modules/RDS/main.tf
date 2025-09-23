data "aws_rds_engine_version" "postgres" {
  engine = "postgres"

  filter {
    name   = "engine"
    values = ["postgres"]
  }

  filter {
    name   = "engine-version"
    values = ["17.6"] # Or just "17" if you want the major version
  }
}

data "aws_secretsmanager_secret" "db_secret" {
  name = "prod/postgres/app-db"
}

data "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = data.aws_secretsmanager_secret.db_secret.id
}

resource "aws_db_subnet_group" "private_subnet_DB" {
  name       = "private_db_subnet"
  subnet_ids = var.private_subnet_ids
  
  tags = {
    Name = "Priavte_subnet_group-${var.Environment}"
  }
}

resource "aws_db_instance" "tf_postgre_db" {
  allocated_storage             = var.Storage_allocation
  db_name                       = "my-tf-db-${var.Environment}"
  engine                        = "postgres"
  engine_version                = data.aws_rds_engine_version.postgres.version
  multi_az                      = var.AZ_availability
  instance_class                = var.db_instance_class
  password                      = jsondecode(data.aws_secretsmanager_secret_version.db_secret_version.secret_string)["password"]
  username                      = jsondecode(data.aws_secretsmanager_secret_version.db_secret_version.secret_string)["username"]
  parameter_group_name          = "default.postgres17"
  storage_type                  = var.storage_type
  storage_encrypted             = true
  auto_minor_version_upgrade    = false
  db_subnet_group_name          = aws_db_subnet_group.private_subnet_DB.name
  vpc_security_group_ids        = [var.rds_sg_id]
  #iam_database_authentication_enabled = true
  enabled_cloudwatch_logs_exports   = ["postgresql"]
  backup_retention_period       = 2
  skip_final_snapshot           = false
  deletion_protection           = true

 
tags ={
  Environment = var.Environment
}

}

