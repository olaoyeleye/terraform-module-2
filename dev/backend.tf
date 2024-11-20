terraform {
  backend "s3" {
    bucket = "kensko"
    key    = "env/nginx/terraform.tfstate"
    region = "eu-west-2"
  }
}
