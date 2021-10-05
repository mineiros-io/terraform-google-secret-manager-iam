[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![Terraform Version][badge-terraform]][releases-terraform]
[![Google Provider Version][badge-tf-gcp]][releases-google-provider]
[![Join Slack][badge-slack]][slack]

# terraform-google-secret-manager-iam

A [Terraform](https://www.terraform.io) module to create a [Google Secret Manager IAM](https://cloud.google.com/secret-manager/docs/access-control) on [Google Cloud Services (GCP)](https://cloud.google.com/).

**_This module supports Terraform version 1
and is compatible with the Terraform Google Provider version 3._**

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.

- [terraform-google-secret-manager-iam](#terraform-google-secret-manager-iam)
  - [Module Features](#module-features)
  - [Getting Started](#getting-started)
  - [Module Argument Reference](#module-argument-reference)
    - [Top-level Arguments](#top-level-arguments)
      - [Module Configuration](#module-configuration)
      - [Main Resource Configuration](#main-resource-configuration)
      - [Extended Resource Configuration](#extended-resource-configuration)
  - [Module Attributes Reference](#module-attributes-reference)
  - [External Documentation](#external-documentation)
    - [Google Documentation](#google-documentation)
    - [Terraform Google Provider Documentation](#terraform-google-provider-documentation)
  - [Module Versioning](#module-versioning)
    - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
  - [About Mineiros](#about-mineiros)
  - [Reporting Issues](#reporting-issues)
  - [Contributing](#contributing)
  - [Makefile Targets](#makefile-targets)
  - [License](#license)

## Module Features

A [Terraform] base module for creating a `google_secret_manager_secret_iam_*` resources.

It allows authoritative bindings (exclusive setting members), non-authoritative (adding additional members), or policy based IAM management of resource level access.

## Getting Started

Most basic usage just setting required arguments:

```hcl
module "terraform-google-secret-manager-iam" {
  source     = "github.com/mineiros-io/terraform-google-secret-manager-iam.git?ref=v0.1.0"

  secret_id  = google_secret_manager_secret.secret-basic.secret_id
  role       = "roles/secretmanager.secretAccessor"
  members    = ["user:admin@example.com"]
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Top-level Arguments

#### Module Configuration

- **`module_enabled`**: _(Optional `bool`)_

  Specifies whether resources in the module will be created.

  Default is `true`.

- **`module_depends_on`**: _(Optional `list(dependencies)`)_

  A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.

  Example:

  ```hcl
  module_depends_on = [
    google_network.network
  ]
  ```

#### Main Resource Configuration

- **`secret_id`**: **_(Required `string`)_**

  The id of the secret.

- **`members`**: **_(Optional `string`)_

  Identities that will be granted the privilege in role. Each entry can have one of the following values:
  - `allUsers`: A special identifier that represents anyone who is on the internet; with or without a Google account.
  - `allAuthenticatedUsers`: A special identifier that represents anyone who is authenticated with a Google account or a service account.
  - `user:{emailid}`: An email address that represents a specific Google account. For example, alice@gmail.com or joe@example.com.
  - `serviceAccount:{emailid}`: An email address that represents a service account. For example, my-other-app@appspot.gserviceaccount.com.
  - `group:{emailid}`: An email address that represents a Google group. For example, admins@example.com.
  - `domain:{domain}`: A G Suite domain (primary, instead of alias) name that represents all the users of that domain. For example, google.com or example.com.

  Default is `[]`.

- **`role`**: **_(Required `string`)_**

  The role that should be applied. Note that custom roles must be of the format `[projects|organizations]/{parent-name}/roles/{role-name}`.

- **`project`**: _(Optional `string`)_

  The resource name of the project the policy is attached to. Its format is `projects/{project_id}`.

- **`authoritative`**: _(Optional `bool`)_

  Whether to exclusively set (authoritative mode) or add (non-authoritative/additive mode) members to the role.

  Default is `true`.

#### Extended Resource Configuration

## Module Attributes Reference

The following attributes are exported in the outputs of the module:

- **`module_enabled`**

  Whether this module is enabled.

- **`iam`**

  All attributes of the created `google_secret_manager_secret_iam_*` resource according to the mode.

## External Documentation

### Google Documentation

- Secret Manager: <https://cloud.google.com/secret-manager/docs>
- Secret Manager Access Control: <https://cloud.google.com/secret-manager/docs/access-control>

### Terraform Google Provider Documentation

- <https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret>
- <https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam>

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

[Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
that solves development, automation and security challenges in cloud infrastructure.

Our vision is to massively reduce time and overhead for teams to manage and
deploy production-grade and secure cloud infrastructure.

We offer commercial support for all of our modules and encourage you to reach out
if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
[Community Slack channel][slack].

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020-2021 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-google-secret-manager-iam
[hello@mineiros.io]: mailto:hello@mineiros.io

<!-- markdown-link-check-enable -->

[badge-build]: https://github.com/mineiros-io/terraform-google-secret-manager-iam/workflows/Tests/badge.svg

<!-- markdown-link-check-enable -->

[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-google-secret-manager-iam.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack

<!-- markdown-link-check-enable -->

[build-status]: https://github.com/mineiros-io/terraform-google-secret-manager-iam/actions
[releases-github]: https://github.com/mineiros-io/erraform-google-secret-manager-iam/releases

<!-- markdown-link-check-enable -->

[releases-terraform]: https://github.com/hashicorp/terraform/releases
[badge-tf-gcp]: https://img.shields.io/badge/google-3.x-1A73E8.svg?logo=terraform
[releases-google-provider]: https://github.com/terraform-providers/terraform-provider-google/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://mineiros.io/slack
[terraform]: https://www.terraform.io
[gcp]: https://cloud.google.com/
[semantic versioning (semver)]: https://semver.org/

<!-- markdown-link-check-disable -->

[variables.tf]: https://github.com/mineiros-io/terraform-google-secret-manager-iam/blob/main/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-google-secret-manager-iam/blob/main/examples
[issues]: https://github.com/mineiros-io/terraform-google-secret-manager-iam/issues
[license]: https://github.com/mineiros-io/terraform-google-secret-manager-iam/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-google-secret-manager-iam/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-google-secret-manager-iam/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-google-secret-manager-iam/blob/main/CONTRIBUTING.md

<!-- markdown-link-check-enable -->