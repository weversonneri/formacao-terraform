module "aws-prod" {
  source         = "../../infra"
  instance_type  = "t2.micro"
  region_aws     = "us-east-2"
  key_name       = "iac-prod"
  ami            = "ami-0a695f0d95cefc163"
  security_group = "PROD"
  min_size       = 1
  max_size       = 10
  group_name     = "prodGroup"
  producao       = true
}


# output "IP" {
#   value = module.aws-prod.ip_publico
# }

