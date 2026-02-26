---
name: terraform-module
description: >
  Terraform and IaC conventions for AWS infrastructure. Auto-loaded when
  creating or modifying Terraform modules, Packer templates, or
  infrastructure configuration.
---

## Module structure

Each module has at minimum:

- `main.tf` — resources
- `variables.tf` — all variables with `description` and `type`
- `outputs.tf` — exported values

Use `validation` blocks for input constraints. Tag all resources with
at minimum: `Name`, `Environment`, `Project`.

## Directory conventions

- Reusable modules live in `modules/`
- Environment-specific configs live in `envs/` (e.g., `envs/staging/`, `envs/production/`)
- Read the project's actual structure before assuming paths

## State management

- Use remote state with locking (S3 + DynamoDB or Terraform Cloud)
- Never commit `.tfstate` files
- Never commit `.tfvars` files with secrets — use environment variables
  or a secrets manager

## Security

- No inline credentials — use IAM roles, instance profiles, or secrets manager
- Security groups follow least-privilege: specific ports, specific CIDR ranges
- Enable encryption at rest for EBS, S3, RDS
- VPC with private subnets for application workloads, public subnets only
  for load balancers

## Conventions

- Run `terraform fmt` before committing
- Pin provider versions explicitly
- Use `data` sources to reference existing resources, not hardcoded IDs/ARNs
- Look up current provider versions — never assume from memory
