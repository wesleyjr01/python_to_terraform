provider "aws" {
  region = var.region

  default_tags { # Tagging vars
    tags = {
      created-by  = "terraform"
      owner       = "cde-wesley"
      email       = "wesley.junior@caylent.com"
      description = "Deployed a Data Lake to test new DMS/Glue features."
    }
  }
}