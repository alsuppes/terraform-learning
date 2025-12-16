terraform {
    backend "s3" {
        bucket = "terraform-state-alsuppes-2025"
        key = "week-2-module-scenarios/terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "terraform-state-locks"
        encrypt = true
    }
}