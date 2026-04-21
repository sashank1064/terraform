# terraform

> Terraform configurations for provisioning AWS infrastructure — VPC, EC2, ALB, IAM, Route 53, Security Groups — written as composable modules.

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?logo=terraform&logoColor=white)
![HCL](https://img.shields.io/badge/HCL-844FBA?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?logo=amazonaws&logoColor=white)

## What this is

Single-environment Terraform code for the AWS infrastructure that underpins the RoboShop deployment. It provisions networking, compute, load balancing, DNS, and IAM — everything the Ansible layer then configures.

For the multi-environment (dev / stage / prod) version with remote state and workspaces, see [`terraform-multi-env`](https://github.com/sashank1064/terraform-multi-env).

## What gets created

| Component | AWS resources |
|---|---|
| **Network** | `aws_vpc`, `aws_subnet` (public + private), `aws_internet_gateway`, `aws_nat_gateway`, route tables |
| **Compute** | `aws_instance` per microservice, tagged for dynamic inventory |
| **Load balancing** | `aws_lb`, `aws_lb_target_group`, `aws_lb_listener` (HTTPS on 443 with ACM cert) |
| **DNS** | `aws_route53_record` per service, private hosted zone |
| **Security** | `aws_security_group` with least-privilege per-service ingress |
| **IAM** | Instance profile with SSM + CloudWatch permissions |
| **Observability** | CloudWatch log groups, metric filters |

## Repo layout

```
.
├── provider.tf            # AWS provider + required versions
├── backend.tf             # S3 remote state + DynamoDB locking
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
└── terraform.tfvars       # (gitignored — env-specific values)
```

## Usage

```bash
# Format + validate before anything else
terraform fmt -recursive
terraform validate

# Initialize backend and providers
terraform init

# See the plan — READ IT, do not just `apply`
terraform plan -out=tfplan

# Apply the reviewed plan
terraform apply tfplan

# When tearing down a dev environment
terraform destroy
```

## Conventions I follow

- **One module per logical concern.** `vpc/`, `ec2/`, `alb/` — never a "stuff" module.
- **No hard-coded values.** Every configurable thing is a variable with a sensible default in `variables.tf`.
- **Tags via a single `locals.common_tags`.** Merged into every resource for cost attribution and cleanup.
- **Remote state + locking.** S3 backend with DynamoDB table so two engineers can't `apply` simultaneously.
- **Provider versions pinned.** `required_providers { aws = "~> 5.0" }` — upgrades are deliberate.
- **`terraform fmt` + `tflint` in CI.** Drift in formatting is drift in code review attention.
- **Outputs are downstream inputs.** ALB DNS, VPC id, and SG ids are outputs so Ansible inventory can consume them.

## Prerequisites

- AWS account and an IAM user / role with the permissions in `iam/policy.json`
- Terraform **>= 1.6**
- AWS CLI v2 configured (`aws configure`)
- S3 bucket + DynamoDB table for remote state (see `backend.tf`)

## What I'd change in production

- Split state by blast-radius: `network/` vs `compute/` vs `data/`
- Add `terraform-docs` to auto-generate module docs
- Gate `apply` behind a PR with `terraform plan` posted as a comment (Atlantis or the GitHub Action)
- Swap the NAT gateway for a NAT instance in dev to save money

---

Part of my DevOps portfolio.
