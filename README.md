# shortpoet-cloud/.github

Shared tooling for the shortpoet-cloud Terraform module repositories: toolchain versions, the `check` task and the tflint ruleset. Changes are released by semver tag.

| File | Purpose |
| --- | --- |
| `mise.toml` | Terraform, tflint and terraform-docs versions, and the `check` task: `terraform fmt`, `validate`, `tflint` and `terraform test` for every directory with `.tf` files |
| `mise run lock` | Re-resolves providers within their constraints and writes `.terraform.lock.hcl` for macOS (arm64) and Linux (amd64) in every Terraform directory. Lock files are committed, so local runs and CI use the same providers |
| `bin/terraform-dirs` | Lists the directories with `.tf` files; both tasks iterate over it |
| `.tflint.hcl` | The tflint ruleset: the built-in terraform plugin with the `all` preset, and the AWS plugin |
| `actions/terraform-module-check` | The same check for CI |

## Local layout

Clone this repository next to the module repositories, and link its `mise.toml` into their shared parent:

```text
<org root>/
  .github/                    this repository
  mise.toml -> .github/mise.toml
  tf-aws-s3/
  tf-iam/
  ...
```

```bash
git clone git@github.com:shortpoet-cloud/.github.git
ln -s .github/mise.toml mise.toml
mise trust mise.toml
```

Mise reads parent-directory config, so `mise run check` works from any module repository. Pre-commit hooks reference the ruleset as `../.github/.tflint.hcl`.

## CI

A module repository runs the check through the action, pinned to a tag of this repository:

```yaml
jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
      - uses: shortpoet-cloud/.github/actions/terraform-module-check@v0.1.0
        with:
          module-source-token: ${{ secrets.SHORTPOET_CLOUD_MODULE_READ_TOKEN }}
```

The action recreates the local layout around the checkout, so the toolchain and ruleset come from the action's own tag. It fetches `git@github.com:` and `ssh://git@github.com/` module sources over HTTPS. `module-source-token` is needed only when a module source is a private repository.
