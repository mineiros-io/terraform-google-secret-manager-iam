generate_hcl "_generated_aws.tf" {
  condition = global.provider == "aws"

  content {
    variable "aws_region" {
      description = "(Optional) The AWS region in which all resources will be created."
      type        = string
      default     = "eu-west-1"
    }

    terraform {
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = global.provider_version_constraint
        }
        random = {
          source  = "hashicorp/random"
          version = "~> 3.1"
        }
      }

      provider "aws" {
        region = var.aws_region
      }

      provider "random" {}

      resource "random_id" "suffix" {
        count       = local.test_name != "unit-disabled" ? 1 : 0
        byte_length = 16
      }

      # define default locals for all tests
      locals {
        test_name     = terramate.stack.path.basename
        random_suffix = try(random_id.suffix[0].hex, "disabled")
      }
    }
  }
}
