terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "weverson-labs"

    workspaces {
      name = "weverson-labs"
    }
  }
}
