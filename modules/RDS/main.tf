##############
# Subner Group
##############
resource "aws_db_subnet_group" "sub_gr" {
  name       = "main"
  subnet_ids = flatten(var.private_subnets_id)

  tags = {
    Name     = "main"
    proyecto = var.proyecto
  }
}

##############
# Instance RDS
##############
resource "aws_db_instance" "my_db_instance" {
  identifier            = var.db_instance_identifier
  engine                = var.engine
  version               = var.version
  port                  = var.port
  multi_az              = var.multiaz
  storage_type          = var.storage_type
  instance_class        = var.instanclase
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  username              = var.db_instance_username
  password              = var.db_instance_password
  publicly_accessible   = false
  skip_final_snapshot   = true
  db_subnet_group_name  = aws_db_subnet_group.sub_gr.name
}
