config {
  call_module_type = "local"
}

plugin "terraform" {
  enabled = true
  preset  = "all"
}

plugin "aws" {
  enabled = true
  version = "0.49.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# Module directories in these repositories are flat (one file per concern), not the
# main.tf/variables.tf/outputs.tf trio this rule prescribes.
rule "terraform_standard_module_structure" {
  enabled = false
}
