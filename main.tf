resource "google_secret_manager_secret_iam_binding" "binding" {
  count = var.module_enabled && var.policy_bindings == null && var.authoritative ? 1 : 0

  project   = var.project
  secret_id = var.secret_id
  role      = var.role
  members   = var.members

  depends_on = [var.module_depends_on]
}

resource "google_secret_manager_secret_iam_member" "member" {
  for_each = var.module_enabled && var.policy_bindings == null && var.authoritative == false ? var.members : []

  project   = var.project
  secret_id = var.secret_id
  role      = var.role
  member    = each.value

  depends_on = [var.module_depends_on]
}

resource "google_secret_manager_secret_iam_policy" "policy" {
  count = var.module_enabled && var.policy_bindings != null ? 1 : 0

  project     = var.project
  secret_id   = var.secret_id
  policy_data = try(data.google_iam_policy.policy[0].policy_data, null)

  depends_on = [var.module_depends_on]
}

data "google_iam_policy" "policy" {
  count = var.module_enabled && var.policy_bindings != null ? 1 : 0

  dynamic "binding" {
    for_each = [for pb in var.policy_bindings : pb if length(tolist(pb.members)) > 0]

    content {
      role    = binding.value.role
      members = binding.value.members

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
