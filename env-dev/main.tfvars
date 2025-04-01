instances = {
  frontend = {
    ami_id = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    ansible_role = "forntend-docker"
  }
  mongodb = {
    ami_id = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
  }
  catalogue = {
    ami_id = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    ansible_role = "catalogue-docker"
  }
  redis = {
    ami_id        = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
  }
  cart = {
    ami_id        = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    ansible_role = "cart-docker"
  }
  payment = {
    ami_id        = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    ansible_role = "payment-docker"
  }
  shipping = {
    ami_id        = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    ansible_role = "shipping-docker"
  }
  dispatch = {
    ami_id        = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    ansible_role = "dispatch-docker"
  }
  rabbitmq = {
    ami_id        = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
  }
  mysql = {
    ami_id        = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
  }
  user = {
    ami_id        = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    ansible_role = "user-docker"
  }
}



zone_id = "Z04349021DA1RQVNS1OQS"


vpc_security_group_ids = ["sg-0eba58b37f791d36a"]

env = "dev"