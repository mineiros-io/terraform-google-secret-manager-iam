# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "secret_id" {
  type        = string
  description = "(Required) The id of the secret."
}

variable "role" {
  type        = string
  description = "(Required) The role that should be applied. Only one 'google_secret_manager_secret_iam_binding' can be used per role. Note that custom roles must be of the format '[projects|organizations]/{parent-name}/roles/{role-name}'."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "project" {
  type        = string
  description = "(Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  default     = null
}

variable "members" {
  type        = set(string)
  description = "(Optional) Identities that will be granted the privilege in role. Role assignment is done according to the 'authoritative' variable. Each entry can have one of the following values: 'allUsers', 'allAuthenticatedUsers', 'serviceAccount:{emailid}', 'group:{emailid}', 'domain:{domain}'."
  default     = []
}

variable "authoritative" {
  type        = bool
  description = "(Optional) Whether to exclusively set (authoritative mode) or add (non-authoritative/additive mode) members to the role."
  default     = true
}

# ------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# ------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether to create resources within the module or not. Default is 'true'."
  default     = true
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends_on. Default is '[]'."
  default     = []
}
