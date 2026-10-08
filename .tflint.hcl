config {
  call_module_type = "local"
}

plugin "terraform" {
  enabled = true
  preset  = "all"
}

# Module directories in these repositories are flat (one file per concern), not the
# main.tf/variables.tf/outputs.tf trio this rule prescribes.
rule "terraform_standard_module_structure" {
  enabled = false
}
