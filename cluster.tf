# Creates RDS Instance

resource "aws_db_instance" "mysql" {
  identifier             = "roboshop-mysql-${var.ENV}"
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  db_name                = "dummy"
  username               = "admin1"
  password               = "RoboShop1"
  parameter_group_name   = aws_db_parameter_group.mysql.name
  skip_final_snapshot    = true    # True only for non prod work loads
  db_subnet_group_name   = aws_db_subnet_group.mysql.name
  vpc_security_group_ids = [aws_security_group.allow_mysql.id]
}

# Creates Parameter group

resource "aws_db_parameter_group" "mysql" {
  name   = "roboshop-mysql-${var.ENV}"
  family = "mysql5.7"
}
# Creates DB subnet Group

resource "aws_db_subnet_group" "mysql" {
  name       = "roboshop-myswl-${var.ENV}"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS

  tags = {
    Name = "roboshop-subnet-group-mysql-${var.ENV}"
  }
}

# Creates Security group for Mysql

 resource "aws_security_group" "allow_mysql" {
   name        = "roboshop-mysql-${var.ENV}"
   description = "roboshop-mysql-${var.ENV}"
   vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description      = "Allow mysql Connection from default vpc"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = [data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR]
  }

   ingress {
     description      = "Allow mysql Connection from Private vpc"
     from_port        = 3306
     to_port          = 3306
     protocol         = "tcp"
     cidr_blocks      = [data.terraform_remote_state.vpc.outputs.VPC_CIDR]
   }
  
   egress {
     from_port        = 0
     to_port          = 0
     protocol         = "-1"
     cidr_blocks      = ["0.0.0.0/0"]
     ipv6_cidr_blocks = ["::/0"]
   }

   tags = {
     Name = "roboshop-mysql-sg-${var.ENV}"
   }
 }

# # Creates redis (Elastic Cache) Cluster

# resource "aws_elasticache_cluster" "redis" {
#   cluster_id           = "redis-${var.ENV}"
#   engine               = "redis"
#   node_type            = "cache.t3.small"
#   num_cache_nodes      = 1       # An ideal prod cluster should have 3 nodes
#   parameter_group_name = aws_elasticache_parameter_group.default.name
#   engine_version       = "6.x"
#   port                 = 6379
#   subnet_group_name    = aws_elasticache_subnet_group.subnet-group.name
#   security_group_ids   = [aws_security_group.allow_redis.id]
# }

# # Creates Parameter group

# resource "aws_elasticache_parameter_group" "default" {
#   name   = "roboshop-redis-${var.ENV}"
#   family = "redis6.x"
# }

# # Created subnet Group
# resource "aws_elasticache_subnet_group" "subnet-group" {
#   name       = "roboshop-redis-${var.ENV}"
#   subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS
# }

# # Creates Security group for redis

# resource "aws_security_group" "allow_redis" {
#   name        = "roboshop-redis-${var.ENV}"
#   description = "roboshop-redis-${var.ENV}"
#   vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

#   ingress {
#     description      = "Allow Redis Connection from default vpc"
#     from_port        = 6379
#     to_port          = 6379
#     protocol         = "tcp"
#     cidr_blocks      = [data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR]
#   }

#   ingress {
#     description      = "Allow redis Connection from Private vpc"
#     from_port        = 6379
#     to_port          = 6379
#     protocol         = "tcp"
#     cidr_blocks      = [data.terraform_remote_state.vpc.outputs.VPC_CIDR]
#   }
  
#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "roboshop-redis-sg-${var.ENV}"
#   }
# }

