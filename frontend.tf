resource "aws_instance" "frontend" {
  ami           = "ami-09c813fb71547fc4f"
  instance_type = "t3.small"
  vpc_security_group_ids = ["sg-0eba58b37f791d36a"]
  tags = {
    Name = "frontend"
  }
  provisioner "remote-exec" {

    connection {
      type     = "ssh"
      user     = "ec2-user"
      password = "DevOps321"
      host     = self.public_ip
    }

    inline = [
      "pip3.11 install ansible",
      "ansibple-pull -i localhost, -U https://github.com/salllmanshaik/Roboshop-Ansible.git roboshop.yml -e component_name=frontend -e env=dev",
    ]
  }
}



resource "aws_route53_record" "frontend" {
  zone_id = "Z04349021DA1RQVNS1OQS"
  name    = "frontend-dev"
  type    = "A"
  ttl     = 10
  records = [aws_instance.frontend.private_ip]
}