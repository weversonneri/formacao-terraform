module "Prod" {
  source = "../../infra"

  name          = "production"
  description   = "Aplicativo-de-producao"
  max_size      = 5
  instance_type = "t2.micro"
  region_aws    = "us-east-2"
  environment   = "production"
  iam_role      = "production"
}

output "IP_alb" {
  value = module.prod.IP
}
