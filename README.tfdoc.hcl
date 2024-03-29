header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-google-secret-manager-iam"

  ### Terraform Badge
  badge "terraform" {
    image = "https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  ### GCP Provider Badge
  badge "tf-gcp" {
    image = "https://img.shields.io/badge/google-4.x-1A73E8.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-google/releases"
    text  = "Google Provider Version"
  }

  ### Slack Badge
  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-google-secret-manager-iam"
  toc     = true
  content = <<-END
    A [Terraform] module to create a [Google Secret Manager IAM](https://cloud.google.com/secret-manager/docs/access-control) on [Google Cloud Services (GCP)](https://cloud.google.com/).

    **_This module supports Terraform version 1
    and is compatible with the Terraform Google Provider version 4._** and 5._**

    This module is part of our Infrastructure as Code (IaC) framework
    that enables our users and customers to easily deploy and manage reusable,
    secure, and production-grade cloud infrastructure.
  END

  section {
    title   = "Module Features"
    content = <<-END
      This module implements the following terraform resources:

      - `google_secret_manager_secret_iam_binding`
      - `google_secret_manager_secret_iam_member`
      - `google_secret_manager_secret_iam_policy`
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
      Most basic usage just setting required arguments:

      ```hcl
      module "terraform-google-secret-manager-iam" {
        source = "github.com/mineiros-io/terraform-google-secret-manager-iam.git?ref=v0.1.0"

        secret_id = google_secret_manager_secret.secret-basic.secret_id
        role      = "roles/secretmanager.secretAccessor"
        members   = ["user:admin@example.com"]
      }
      ```
    END
  }

  section {
    title   = "Module Argument Reference"
    content = "See [variables.tf] and [examples/] for details and use-cases."

    section {
      title = "Top-level Arguments"

      section {
        title = "Main Resource Configuration"

        variable "secret_id" {
          required    = true
          type        = string
          description = "The id of the secret."
        }

        variable "members" {
          type        = set(string)
          default     = []
          description = <<-END
            Identities that will be granted the privilege in role. Each entry can have one of the following values:
            - `allUsers`: A special identifier that represents anyone who is on the internet; with or without a Google account.
            - `allAuthenticatedUsers`: A special identifier that represents anyone who is authenticated with a Google account or a service account.
            - `user:{emailid}`: An email address that represents a specific Google account. For example, alice@gmail.com or joe@example.com.
            - `serviceAccount:{emailid}`: An email address that represents a service account. For example, my-other-app@appspot.gserviceaccount.com.
            - `group:{emailid}`: An email address that represents a Google group. For example, admins@example.com.
            - `domain:{domain}`: A G Suite domain (primary, instead of alias) name that represents all the users of that domain. For example, google.com or example.com.
            - `projectOwner:projectid`: Owners of the given project. For example, `projectOwner:my-example-project`
            - `projectEditor:projectid`: Editors of the given project. For example, `projectEditor:my-example-project`
            - `projectViewer:projectid`: Viewers of the given project. For example, `projectViewer:my-example-project`
            - `computed:{identifier}`: An existing key from var.computed_members_map.
            END
        }

        variable "computed_members_map" {
          type        = map(string)
          default     = {}
          description = <<-END
             A map of identifiers to identities to be replaced in 'var.members' or in members of `policy_bindings` to handle terraform computed values.
             The format of each value must satisfy the format as described in `var.members`.
           END
          # TODO: terradoc does not allow use of variables in examples
          # readme_example = <<-END
          #   members = [
          #     "user:member@example.com",
          #     "computed:myserviceaccount",
          #   ]
          #   computed_members_map = {
          #     myserviceaccount = "serviceAccount:${google_service_account.service_account.id}"
          #   }
          # END
        }

        variable "role" {
          type        = string
          description = <<-END
            The role that should be applied.
            Note that custom roles must be of the format `[projects|organizations]/{parent-name}/roles/{role-name}`.
            Must be set if `policy_bindings` is unset.
          END
        }

        variable "project" {
          type        = string
          description = "The ID of the project in which the resource belongs. If it is not provided, the project will be parsed from the identifier of the parent resource. If no project is provided in the parent identifier and no project is specified, the provider project is used."
        }

        variable "authoritative" {
          type        = bool
          description = "Whether to exclusively set (authoritative mode) or add (non-authoritative/additive mode) members to the role."
          default     = true
        }

        variable "policy_bindings" {
          type           = list(policy_binding)
          description    = "A list of IAM policy bindings. If set, `role` is ignored and a policy_binding is created."
          readme_example = <<-END
            policy_bindings = [
              {
                role    = "roles/secretmanager.secretAccessor"
                members = [
                  "user:member@example.com",
                ]
              }
            ]
          END

          attribute "role" {
            required    = true
            type        = string
            description = "The role that will be grated to the members."
          }

          attribute "members" {
            required    = true
            type        = set(string)
            description = <<-END
              A set of identities that will be granted the privilege in role. Each entry can have one of the following values:

              - `allUsers`: A special identifier that represents anyone who is on the internet; with or without a Google account.
              - `allAuthenticatedUsers`: A special identifier that represents anyone who is authenticated with a Google account or a service account.
              - `user:{emailid}`: An email address that represents a specific Google account. For example, `alice@gmail.com` or `joe@example.com`.
              - `serviceAccount:{emailid}`: An email address that represents a service account. For example, `my-other-app@appspot.gserviceaccount.com`.
              - `group:{emailid}`: An email address that represents a Google group. For example, `admins@example.com`.
              - `domain:{domain}`: A G Suite domain (primary, instead of alias) name that represents all the users of that domain. For example, `google.com` or `example.com`.
            END
          }

          attribute "condition" {
            type           = object(condition)
            description    = "An IAM Condition for a given binding."
            readme_example = <<-END
              condition = {
                expression = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
                title      = "expires_after_2021_12_31"
              }
            END

            attribute "expression" {
              required    = true
              type        = string
              description = "Textual representation of an expression in Common Expression Language syntax."
            }

            attribute "title" {
              required    = true
              type        = string
              description = "A title for the expression, i.e. a short string describing its purpose."
            }

            attribute "description" {
              type        = string
              description = "An optional description of the expression. This is a longer text which describes the expression, e.g. when hovered over it in a UI."
            }
          }
        }
      }

      section {
        title = "Module Configuration"

        variable "module_enabled" {
          type        = bool
          description = "Specifies whether resources in the module will be created."
          default     = true
        }

        variable "module_depends_on" {
          type           = list(dependency)
          description    = "A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency."
          readme_example = <<-END
            module_depends_on = [
              null_resource.name
            ]
          END
        }
      }

    }
  }

  section {
    title   = "Module Attributes Reference"
    content = <<-END
      The following attributes are exported in the outputs of the module:

      - **`module_enabled`**

        Whether this module is enabled.

      - **`iam`**

        All attributes of the created `iam_binding` or `iam_member` or `iam_policy` resource according to the mode.
    END
  }

  section {
    title   = "Module Outputs"
    content = <<-END
      The following attributes are exported in the outputs of the module:
    END

    output "iam" {
      type        = object(iam)
      description = <<-END
        All attributes of the created `iam_binding` or `iam_member` or
        `iam_policy` resource according to the mode.
      END
    }
  }

  section {
    title = "External Documentation"

    section {
      title   = "Google Documentation"
      content = <<-END
        - Secret Manager: <https://cloud.google.com/secret-manager/docs>
        - Secret Manager Access Control: <https://cloud.google.com/secret-manager/docs/access-control>
      END
    }

    section {
      title   = "Terraform Google Provider Documentation"
      content = <<-END
        - <https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret>
        - <https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam>
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      [Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
      that solves development, automation and security challenges in cloud infrastructure.

      Our vision is to massively reduce time and overhead for teams to manage and
      deploy production-grade and secure cloud infrastructure.

      We offer commercial support for all of our modules and encourage you to reach out
      if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
      [Community Slack channel][slack].
    END
  }

  section {
    title   = "Reporting Issues"
    content = "We use GitHub [Issues] to track community reported issues and missing features."
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2021 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-google-secret-manager-iam"
  }
  ref "hello@mineiros.io" {
    value = " mailto:hello@mineiros.io"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://mineiros.io/slack"
  }
  ref "terraform" {
    value = "https://www.terraform.io"
  }
  ref "semantic versioning (semver)" {
    value = "https://semver.org/"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-google-secret-manager-iam/blob/main/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-google-secret-manager-iam/blob/main/examples"
  }
  ref "issues" {
    value = "https://github.com/mineiros-io/terraform-google-secret-manager-iam/issues"
  }
  ref "license" {
    value = "https://github.com/mineiros-io/terraform-google-secret-manager-iam/blob/main/LICENSE"
  }
  ref "makefile" {
    value = "https://github.com/mineiros-io/terraform-google-secret-manager-iam/blob/main/Makefile"
  }
  ref "pull requests" {
    value = "https://github.com/mineiros-io/terraform-google-secret-manager-iam/pulls"
  }
  ref "contribution guidelines" {
    value = "https://github.com/mineiros-io/terraform-google-secret-manager-iam/blob/main/CONTRIBUTING.md"
  }
}
