resource "aws_instance" "instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id              = var.subnet_ids[0]
  root_block_device {
    volume_size = var.root_volume_size
    encrypted = true
    kms_key_id = var.kms_arn
  }
  tags = {
    Name = var.name
    monitor = "true"
  }
}

resource "aws_security_group" "main" {
  name        = "${var.name}-sg"
  description = "${var.name}-sg"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  for_each          = var.bastion_ssh_nodes
  description       = each.key
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = each.value
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  tags = {
    Name = each.key
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_db" {
  for_each          = var.app_cidr
  description       = each.key
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = each.value
  from_port         = var.port
  ip_protocol       = "tcp"
  to_port           = var.port
  tags = {
    Name = each.key
  }
}

resource "aws_route53_record" "record" {
  zone_id = var.zone_id
  name    = "${var.name}-${var.env}"
  type    = "A"
  ttl     = 10
  records = [aws_instance.instance.private_ip]
}

resource "null_resource" "main" {
  depends_on = [aws_route53_record.record]

  triggers = {
    instance_id_change = aws_instance.instance.id
  }

  provisioner "remote-exec" {

    connection {
      type     = "ssh"
      user     = data.vault_generic_secret.ssh.data["username"]
      password = data.vault_generic_secret.ssh.data["password"]
      host     = aws_instance.instance.private_ip
    }


    inline = [
      "sudo pip3.11 install ansible hvac",
      "ansible-pull -i localhost, -U https://github.com/salllmanshaik/Roboshop-Ansible.git roboshop.yaml -e component_name=${var.ansible_role} -e env=${var.env} -e vault_token=${var.vault_token}",
    ]
  }

}