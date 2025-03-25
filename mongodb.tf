resource "aws_instance" "mongodb" {
  ami           = "ami-09c813fb71547fc4f"
  instance_type = "t3.small"
  vpc_security_group_ids = ["sg-0eba58b37f791d36a"]
  tags = {
    Name = "mongodb"
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
      "ansible-pull -i localhost, -U https://github.com/salllmanshaik/Roboshop-Ansible.git roboshop.yml -e component_name=mongodb -e env=dev",
    ]
  }
}



resource "aws_route53_record" "mongodb" {
  zone_id = "Z04349021DA1RQVNS1OQS"
  name    = "mongo-dev"
  type    = "A"
  ttl     = 10
  records = [aws_instance.mongodb.private_ip]
}