data "aws_ami" "latest" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["${var.proj_name}-${var.proj_env}-*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "tag:project"
    values = [var.proj_name]
  }
 filter {
    name   = "tag:env"
    values = [var.proj_env]
  }
}
