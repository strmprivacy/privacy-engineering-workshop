terraform {
  backend "gcs" {
    bucket = "stream-machine-provisioning-dev"
    prefix = "projects/privacy-engineering-workshop"
  }
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 4.49.0"
    }
  }
  required_version = ">= 1.0.1"
}

module "dev" {
  source = "git::ssh://git@gitlab.com/strmprivacy/provisioning/contexts.git//dev"
}

provider "google" {
  project = module.dev.project_id
  region = module.dev.default_region
  zone = module.dev.default_zone
}
