# Create an Amazon RDS MySQL database

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = flatten(var.private_subnets_id)

  tags = {
    Name = "main"
  }
}

resource "aws_db_instance" "my_db_instance" {
  identifier             = var.db_instance_identifier
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  username               = var.db_instance_username
  password               = var.db_instance_password
  publicly_accessible    = false
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.default.name
}
