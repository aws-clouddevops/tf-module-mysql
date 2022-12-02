data "terraform_remote_state" "vpc" {
    backend = "s3"

    config = {
        bucket     = "bsg-tf-state-bucket"
        key        = "vpc/${var.ENV}/terraform.tfstate"
        region     = "us-east-1"  

    }
}

# ref: https://developer.hashicorp.com/terraform/language/state/remote-state-data