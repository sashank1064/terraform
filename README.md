# Terraform Patterns Reference

A focused workspace of runnable Terraform examples — one concept per folder: variables, locals, loops, conditions, data sources, dynamic blocks, provisioners, imports, remote state, multi-account.

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?logo=terraform&logoColor=white)
![HCL](https://img.shields.io/badge/HCL-844FBA?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?logo=amazonaws&logoColor=white)

## Overview

A reference repo for Terraform language and workflow patterns. Each folder is self-contained: its own `provider.tf`, its own `.tf` files, its own purpose. No folder depends on another, so you can pick any topic and run it in isolation.

For the real RoboShop infrastructure that composes these patterns into a working platform, see:

- [`terraform-aws-vpc`](https://github.com/sashank1064/terraform-aws-vpc), [`terraform-aws-securitygroup`](https://github.com/sashank1064/terraform-aws-securitygroup), [`terraform-aws-instance`](https://github.com/sashank1064/terraform-aws-instance): published reusable modules
- [`terraform-aws-roboshop`](https://github.com/sashank1064/terraform-aws-roboshop): component-level infra that consumes those modules
- [`roboshop-infra-dev`](https://github.com/sashank1064/roboshop-infra-dev): layered deployment from VPC to CDN

## Topics covered

| Folder | What it shows |
|---|---|
| `variables/` | Variable declarations, defaults, validation blocks |
| `locals/` | Computed values, naming helpers, common tags |
| `conditions/` | `count` and `for_each` gating with booleans |
| `loops/` | `count`, `for_each`, and `for` expressions |
| `for-loop/` | `for` expressions across lists and maps |
| `dynamic-block/` | `dynamic` blocks for repeated nested configs |
| `functions/` | String, collection, numeric, and type functions |
| `data-sources/` | Reading existing AWS resources into Terraform |
| `provisioners/` | `remote-exec`, `local-exec`, and when to avoid them |
| `import/` | `terraform import` and `import` blocks for adopting real resources |
| `state/` | Local state inspection with `terraform state` subcommands |
| `secure-state/` | Remote backend, encryption, locking with DynamoDB |
| `multi-account/` | Provider aliases for cross-account deployments |
| `ec2/` | Minimal EC2 + SG example used as a sandbox |

## Quick start

```bash
# Pick a topic folder
cd ec2

# Standard flow
terraform init
terraform plan
terraform apply
terraform destroy
```

Every folder follows the same flow. No surprises.

## Conventions

- **`provider.tf` per folder.** Each example runs on its own.
- **`.terraform.lock.hcl` committed.** Provider versions are reproducible.
- **No hard-coded credentials.** AWS access comes from the environment (`aws configure` or an assumed role).
- **Destroy-friendly.** Examples are built to be spun up, inspected, and torn down cheaply.

