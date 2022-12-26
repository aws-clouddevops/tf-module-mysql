data "terraform_remote_state" "vpc" {
    backend = "s3"

    config = {
        bucket     = "bsg-tf-state-bucket"
        key        = "vpc/${var.ENV}/terraform.tfstate"
        region     = "us-east-1"  

    }
}

# ref: https://developer.hashicorp.com/terraform/language/state/remote-state-data

data "aws_secretsmanager_secret" "secrets" {
    name = "roboshop/secrets"
}

data "aws_secretsmanager_secret_version" "secrets" {
    secret_id = data.aws_secretsmanager_secret.secrets.id
}