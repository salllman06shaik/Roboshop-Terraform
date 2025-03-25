resource "aws_instance" "instance" {
  for_each = var.instances
  ami           = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids
  tags = {
    Name = each.key
  }
}


resource "aws_route53_record" "record" {
  for_each = var.instances
  zone_id = var.zone_id
  name    = "${each.key}-${var.env}"
  type    = "A"
  ttl     = 10
  records = [aws_instance.instance[each.key].private_ip]
}

#resource "null_resource" "frontend" {
#  provisioner "remote-exec" {
#
#    connection {
#      type     = "ssh"
#      user     = "ec2-user"
#      password = "DevOps321"
#      host     = aws_instance.instance[count.index].private_ip
#    }
#
#    inline = [
#      "sudo pip3.11 install ansible",
#      "ansible-pull -i localhost, -U https://github.com/salllmanshaik/Roboshop-Ansible.git roboshop.yml -e component_name=frontend -e env=dev",
#    ]
#  }
#
#}