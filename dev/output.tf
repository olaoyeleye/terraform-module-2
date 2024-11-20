data "terraform_remote_state" "remote"{
  backend="s3"
  config = {
    bucket = "kensko"
    key    = "env/dev/terraform.tfstate"
    region = "eu-west-2"
  }
}


#output "nginx" {
#    value =data.terraform_remote_state.remote.public_dns
#}

#output "python" {
#    value =data.terraform_remote_state.remote.public_dns
#}