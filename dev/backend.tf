terraform {
  backend "s3" {
    bucket = "techbleat-terraform-store"
    key    = "env/dev/terraform.tfstate"
    region = "eu-west-2"
  }
}
