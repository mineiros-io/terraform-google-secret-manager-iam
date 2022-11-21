locals {
  create_binding = var.module_enabled && var.policy_bindings == null && var.authoritative
  create_member  = var.module_enabled && var.policy_bindings == null && var.authoritative == false
  create_policy  = var.module_enabled && var.policy_bindings != null
}

resource "google_secret_manager_secret_iam_binding" "binding" {
  count = local.create_binding ? 1 : 0

  project   = var.project
  secret_id = var.secret_id
  role      = var.role
  members   = [for m in var.members : try(var.computed_members_map[regex("^computed:(.*)", m)[0]], m)]

  depends_on = [var.module_depends_on]
}

resource "google_secret_manager_secret_iam_member" "member" {
  for_each = local.create_member ? var.members : []

  project   = var.project
  secret_id = var.secret_id
  role      = var.role
  member    = try(var.computed_members_map[regex("^computed:(.*)", each.value)[0]], each.value)

  depends_on = [var.module_depends_on]
}

resource "google_secret_manager_secret_iam_policy" "policy" {
  count = local.create_policy ? 1 : 0

  project     = var.project
  secret_id   = var.secret_id
  policy_data = try(data.google_iam_policy.policy[0].policy_data, null)

  depends_on = [var.module_depends_on]
}

data "google_iam_policy" "policy" {
  count = local.create_policy ? 1 : 0

  dynamic "binding" {
    for_each = var.policy_bindings

    content {
      role    = binding.value.role
      members = [for m in binding.value.members : try(var.computed_members_map[regex("^computed:(.*)", m)[0]], m)]

      dynamic "condition" {
        for_each = try([binding.value.condition], [])

        content {
          expression  = condition.value.expression
          title       = condition.value.title
          description = try(condition.value.description, null)
        }
      }
    }
  }
}
