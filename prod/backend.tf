terraform {
  backend "s3" {
    bucket = "techbleat-terraform-store"
    key    = "env/prod/terraform.tfstate"
    region = "eu-west-2"
  }
}
