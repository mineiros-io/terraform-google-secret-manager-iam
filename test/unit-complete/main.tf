module "test" {
  source = "../.."

  # add all required arguments

  secret_id = "unit-complete"

  role = "roles/editor"

  # add all optional arguments that create additional/extended resources

  # add most/all other optional arguments
}
