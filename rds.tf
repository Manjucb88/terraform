resource "aws_db_instance" "default" {
 storage_encrypted = true
 backup_retention_period = 5
 identifier                = "test"
  engine            = "mysql"
  engine_version    = "5.7.25"
  instance_class    = "db.t2.small"
  allocated_storage = 5
 name  = "demodb"
  username = "user"
  password                  = "password"
  parameter_group_name    = "default.mysql5.7"
  db_subnet_group_name="${aws_db_subnet_group.default.id}"
  availability_zone="${aws_subnet.private_1.availability_zone}"
  skip_final_snapshot       = true
  final_snapshot_identifier = "Ignore"
}

