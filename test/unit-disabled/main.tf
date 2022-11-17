module "test" {
  source = "../.."

  module_enabled = false

  # add all required arguments

  secret_id = "unit-disabled"

  # add all optional arguments that create additional/extended resources
}
