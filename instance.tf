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

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  subnet_id = "subnet-055c96e984dd3d4ef"
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.sg["app_sg"].id
  ]

  user_data = <<-EOF
    #!/bin/bash
    apt update -y ; apt install apache2 -y ; systemctl start apache2
  EOF

  tags = {
    Name = "HelloWorld"
  }

  depends_on = [aws_security_group.sg]
}

resource "time_sleep" "delay" {
  create_duration = "60s"

  depends_on = [
    aws_instance.web
  ]
}

### Validation using data
data "http" "data_ec2_validation" {
  url = "http://${aws_instance.web.public_ip}"
  insecure = true

  lifecycle {
    postcondition {
      condition = self.status_code == 200
      error_message = "${self.url} returned an unhealthy status code"
    }
  }

  depends_on = [aws_instance.web, time_sleep.delay]
}

### Validation using check
check "response" {
  data "http" "check_ec2_validation" {
    url = "http://${aws_instance.web.public_ip}"
    insecure = true

    depends_on = [aws_instance.web, time_sleep.delay]
  }

  assert {
    condition = data.http.check_ec2_validation.status_code == 200
    error_message = "EC2 check returns unhealthy status code"
  }
}