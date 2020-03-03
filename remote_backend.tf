terraform {
  backend "s3" {
    bucket = "tardigrade-wavestone-terraform-state"
    key    = "terraform.tfstate"
    region = "eu-west-3"
  }
}
