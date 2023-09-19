terraform {
  backend "s3" {
    bucket = "terraform-weverson-labs"
    key    = "hml/terraform.tfstate"
    region = "us-east-2"
  }
}
