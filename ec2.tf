provider "aws" {
  region = var.region
}

resource "aws_instance" "ubuntu_instance" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name
  subnet_id     = aws_subnet.cia.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id,
    aws_security_group.allow_http.id,
    aws_security_group.allow_https.id
  ]

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }

  associate_public_ip_address = true
  user_data                   = <<-EOF
              #!/bin/bash
              dpkg -i /var/NessusAgent.deb
              /bin/systemctl start nessusagent.service
              EOF
  tags = {
    Name = "tenable-rpm"
  }
}
