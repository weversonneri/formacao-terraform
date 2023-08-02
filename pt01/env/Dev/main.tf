module "aws-dev" {
  source         = "../../infra"
  instance_type  = "t2.micro"
  region_aws     = "us-west-2"
  key_name       = "iac-dev"
  ami            = "ami-0735c191cf914754d"
  security_group = "DEV"
  min_size       = 0
  max_size       = 1
  group_name     = "devGroup"
  producao       = false
}

# output "IP" {
#   value = module.aws-dev.ip_publico
# }
