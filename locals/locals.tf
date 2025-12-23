locals {
  final_name = "${var.Project}-${var.environment}-${var.component}"
  ec2_tags = merge(
    var.common_tags, {
      environment = "dev"
      version     = "1.0"

    }
  )
}