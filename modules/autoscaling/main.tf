data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_launch_template" "this" {
  name = "${var.name}-lt"
  instance_type = var.instance_type
  image_id = data.aws_ami.ubuntu.id
}

resource "aws_autoscaling_group" "this" {
  name = "${var.name}-asg"
  max_size = var.asg_size.max_size
  min_size = var.asg_size.min_size
  desired_capacity = var.asg_size.desired_capacity

  vpc_zone_identifier = var.subnets

  launch_template {
    id = aws_launch_template.this.id
    version = "$Latest"
  }
}

resource "aws_ssm_parameter" "replicated_id" {
  name  = "/asg/id"
  type  = "String"
  value = aws_autoscaling_group.this.id

  provider = aws.central
}