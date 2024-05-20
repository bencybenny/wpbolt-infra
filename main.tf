#----------------------------------------------------------------------------
#                      Keypair creation
#----------------------------------------------------------------------------

resource "aws_key_pair" "wpbolt" {
  key_name   = "${var.proj_name}-${var.proj_env}"
  public_key = file("mykey.pub")
  tags = {
    Name    = "${var.proj_name}-${var.proj_env}"
    project = var.proj_name
    env     = var.proj_env
  }
}

#----------------------------------------------------------------------------
#                      SecurityGroup
#----------------------------------------------------------------------------
resource "aws_security_group" "wpbolt" {
  name        = "${var.proj_name}-${var.proj_env}-webserver-access"
  description = "${var.proj_name}-${var.proj_env}-webserver-access"
  ingress {
    description      = "http traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "https traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
ingress {
    description      = "ssh traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name    = "${var.proj_name}-${var.proj_env}-weberver-access"
    project = var.proj_name
    env     = var.proj_env
  }
}

#-------------------------------------------------------------------------------
#                 Creation of ec2 instance
#-------------------------------------------------------------------------------

resource "aws_instance" "wpbolt" {
ami                    = data.aws_ami.latest.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.wpbolt.id]
  tags = {
    Name    = "${var.proj_name}-${var.proj_env}-wpbolt"
    project = var.proj_name
    env     = var.proj_env
  }
}

#----------------------------------------------------------------------------
#                      Creating Records in Route53- prod
#----------------------------------------------------------------------------
resource "aws_route53_record" "wpbolt-prod" {

 count = var.proj_env == "prod" ? 1 : 0
  zone_id = var.hosted_zone_id
  name    = "${var.hostname-prod}.${var.hosted_zone_name}"
  type    = "A"
  ttl     = "30"
  records = [ aws_instance.wpbolt.public_ip ]
}
#----------------------------------------------------------------------------
#                      Creating Records in Route53- dev
#----------------------------------------------------------------------------
resource "aws_route53_record" "wpbolt-dev" {

 count = var.proj_env == "dev" ? 1 : 0
  zone_id = var.hosted_zone_id
  name    = "${var.hostnamdev}.${var.hosted_zone_name}"
  type    = "A"
  ttl     = "30"
  records = [ aws_instance.wpbolt.public_ip ]
}

