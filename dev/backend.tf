terraform {
  backend "s3" {
    bucket = "kensko"
    key    = "env/dev/terraform.tfstate"
    region = "eu-west-2"
  }
}
