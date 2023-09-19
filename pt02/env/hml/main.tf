module "Hml" {
  source = "../../infra"

  name          = "homogation"
  description   = "Aplicativo-de-homologacao"
  max_size      = 3
  instance_type = "t2.micro"
  region_aws    = "us-east-2"
  environment   = "ambiente-hml"
}
