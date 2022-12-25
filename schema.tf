resource "null_resource" "mysql-schema" {
  depends_on = [aws_db_instance.mysql]
  provisioner "local-exec" {
    command = <<EOF
   cd /tmp/
   curl -s -L -o /tmp/mysql.zip "https://github.com/stans-robot-project/mysql/archive/main.zip"
   unzip mysql.zip
   cd mysql-main
   mysql -h ${aws_db_instance.mysql.address}  -uadmin1 -pRoboShop1 < shipping.sql
  EOF
  }
}

# Install Mysql on the jenkins node
# Check on the jenkins node if the schema is loaded using the command mysql -h the end point that comes up -uadmin1 -pRoboShop1