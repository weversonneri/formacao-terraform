terraform {
  backend "s3" {
    bucket = "terraform-weverson-labs"
    key    = "prod/terraform.tfstate"
    region = "us-east-2"
  }
}
