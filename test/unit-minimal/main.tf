module "test" {
  source = "../.."

  secret_id = "unit-minimal"
  role      = "roles/editor"
}

module "test2" {
  source = "../.."

  secret_id = "unit-minimal"

  policy_bindings = [
    {
      role = "roles/secretmanager.secretAccessor"
      members = [
        "user:member@example.com",
      ]
    }
  ]
}
