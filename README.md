# Terraform automation for Proxmox
Creation of proxmox lxc on LAN - safe for tests

## Terraform Module Usage Guide

This repo contains a minimal Terraform root module split across four files:

- `versions.tf` pins Terraform and required provider versions
- `provider.tf` configures providers (authentication and endpoints)
- `variables.tf` declares inputs you must supply
- `main.tf` defines the actual infrastructure resources

The split is purely organizational. Terraform loads all `*.tf` files in this directory as one configuration.

## What you need installed

- Terraform CLI
- Credentials for the target platform your `provider.tf` is configured for (Proxmox, Cloudflare, etc.)

If you use multiple providers, install nothing extra. Terraform downloads providers automatically during `terraform init`.

## Repository layout

Recommended layout for a clean, public-safe repo:

```text
.
├── main.tf
├── provider.tf
├── variables.tf
├── versions.tf
├── README.md
├── LICENSE
├── env.example
├── terraform.tfvars.example
├── modules/                  # optional reusable modules you write
├── templates/                # optional cloud-init / user-data templates
├── scripts/                  # optional helper scripts
└── .gitignore
````

Notes:

* Keep this root folder as the place you run `terraform init/plan/apply`.
* Put anything sensitive in local-only files and ignore them via `.gitignore`.

## How these files work together

### versions.tf

Purpose:

* Requires a minimum Terraform version
* Pins provider versions to avoid surprise breakages

What you change:

* Rarely. Update versions intentionally and test.

### provider.tf

Purpose:

* Declares provider blocks and how Terraform authenticates
* Often includes things like endpoint URLs and API tokens

Common patterns:

* Provider config uses variables (recommended)
* Provider config reads env vars (also common)

What you change:

* Provider endpoint, authentication method, region or datacenter defaults

### variables.tf

Purpose:

* Defines all inputs expected by this configuration
* Defines types, defaults, and descriptions

What you change:

* Add new variables when you add new configurable behavior to `main.tf`

### main.tf

Purpose:

* Defines resources, data sources, outputs, and module calls

What you change:

* Most of your work happens here

## Required local files

You should create these locally and keep them out of Git history.

### 1) .env (local only)

Terraform itself does not automatically load `.env`, but you can use it in two common ways:

Option A: Use a shell to export variables before running Terraform

```bash
set -a
source ./.env
set +a
terraform plan
```

Option B: Use `direnv` (recommended for repeatability)

* Install direnv
* Create `.envrc` that loads `.env`
* Allow it with `direnv allow`

This repo recommends Option A unless you already use direnv.

#### Example `.env` template

Create a file named `.env` and fill it with your real values.

If you are using the Proxmox provider, typical variables look like:

```bash
# Proxmox API
PM_API_URL="https://proxmox.example.com:8006/api2/json"
PM_API_TOKEN_ID="root@pam!terraform"
PM_API_TOKEN_SECRET="paste_token_secret_here"

# Optional
PM_TLS_INSECURE="false"
```

If you are using Cloudflare for DNS, typical variables look like:

```bash
CLOUDFLARE_API_TOKEN="paste_token_here"
CLOUDFLARE_ZONE_ID="paste_zone_id_here"
```

If your `provider.tf` references different names, match whatever it expects.

Also include any module inputs you prefer to provide as env vars (less common than tfvars).

### 2) terraform.tfvars (local only)

This is the standard way to provide variables Terraform reads automatically.

Create `terraform.tfvars`:

```hcl
# Example variables. Replace with the variables defined in variables.tf.
project_name = "example"
environment  = "dev"
```

If you want to keep values shareable without secrets, commit a `terraform.tfvars.example` and keep the real `terraform.tfvars` ignored.

## .gitignore

Create `.gitignore` in the repo root:

```gitignore
# Terraform local state and working dirs
.terraform/
.terraform.lock.hcl

# State files
terraform.tfstate
terraform.tfstate.*
*.tfstate
*.tfstate.*

# Plans
*.tfplan

# Variable files with secrets
terraform.tfvars
*.tfvars
*.tfvars.json

# Local overrides
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Crash logs
crash.log

# Environment files
.env
.env.*
.envrc

# Keys and certs
*.pem
*.key
id_rsa*
secrets/
certs/

# Editor and OS noise
.DS_Store
.idea/
.vscode/
*.swp
```

Keep `*.tf` files committed. Never commit state, tfvars, or secrets.

## Running it

From the repo root:

1. Initialize providers

```bash
terraform init
```

2. Validate configuration

```bash
terraform validate
```

3. Review changes (read-only)

```bash
terraform plan
```

4. Apply changes (writes infrastructure)

```bash
terraform apply
```

5. Destroy (removes what this config created)

```bash
terraform destroy
```

## Common workflow for safe public repos

* Commit only `*.tf`, `README.md`, `LICENSE`, and non-secret examples like:

  * `env.example`
  * `terraform.tfvars.example`
* Put real values in `.env` and `terraform.tfvars`, and keep both ignored.

## Troubleshooting

### Provider auth errors

* Double check env var names match what `provider.tf` expects
* Confirm tokens are valid and have required permissions
* Verify endpoint URL is reachable from where you run Terraform

### Plan shows unexpected replacements

* Provider version drift: rerun `terraform init -upgrade` only when you intend to upgrade
* Input changes: check `terraform.tfvars` and any exported env vars
