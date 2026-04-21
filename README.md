# terraform

Terraform configurations for provisioning AWS infrastructure: VPC, EC2, ALB, IAM, Route 53, and security groups, written as composable modules.

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?logo=terraform&logoColor=white)
![HCL](https://img.shields.io/badge/HCL-844FBA?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?logo=amazonaws&logoColor=white)

## Overview

Single-environment Terraform code for the AWS infrastructure that underpins the RoboShop deployment. It provisions networking, compute, load balancing, DNS, and IAM. The Ansible layer then configures the services that run on top.

For the multi-environment version (dev, stage, prod with remote state and workspaces), see [`terraform-multi-env`](https://github.com/sashank1064/terraform-multi-env).

## What gets created

| Component | AWS resources |
|---|---|
| Network | `aws_vpc`, `aws_subnet` (public + private), `aws_internet_gateway`, `aws_nat_gateway`, route tables |
| Compute | `aws_instance` per microservice, tagged for dynamic inventory |
| Load balancing | `aws_lb`, `aws_lb_target_group`, `aws_lb_listener` (HTTPS on 443 with ACM cert) |
| DNS | `aws_route53_record` per service, private hosted zone |
| Security | `aws_security_group` with least-privilege per-service ingress |
| IAM | Instance profile with SSM and CloudWatch permissions |
| Observability | CloudWatch log groups, metric filters |

## Repo layout

```
.
├── provider.tf            # AWS provider and required versions
├── backend.tf             # S3 remote state and DynamoDB locking
├── variables.tf           # input vars (region, instance size, tags)
├── locals.tf              # computed defaults, naming helpers
├── main.tf                # module composition
├── outputs.tf             # ALB DNS, VPC id, private IPs
├── modules/
│   ├── vpc/
│   ├── ec2/
│   ├── alb/
│   ├── route53/
│   ├── sg/
│   └── iam/
└── terraform.tfvars       # gitignored, env-specific values
```

## Usage

```bash
# Format and validate before anything else
terraform fmt -recursive
terraform validate

# Initialize backend and providers
terraform init

# See the plan, read it, do not just apply
terraform plan -out=tfplan

# Apply the reviewed plan
terraform apply tfplan

# When tearing down a dev environment
terraform destroy
```

## Conventions

- **One module per logical concern.** `vpc/`, `ec2/`, `alb/`, never a "stuff" module.
- **No hard-coded values.** Every configurable thing is a variable with a sensible default in `variables.tf`.
- **Tags via a single `locals.common_tags`.** Merged into every resource for cost attribution and cleanup.
- **Remote state and locking.** S3 backend with DynamoDB table so two engineers can't `apply` simultaneously.
- **Provider versions pinned.** `required_providers { aws = "~> 5.0" }`. Upgrades are deliberate.
- **`terraform fmt` and `tflint` in CI.** Drift in formatting is drift in code review attention.
- **Outputs are downstream inputs.** ALB DNS, VPC id, and SG ids are outputs so Ansible inventory can consume them.

## Prerequisites

- AWS account and an IAM user or role with the permissions in `iam/policy.json`
- Terraform >= 1.6
- AWS CLI v2 configured (`aws configure`)
- S3 bucket and DynamoDB table for remote state (see `backend.tf`)
