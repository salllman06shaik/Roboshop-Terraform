instances = {
  frontend = {
    ami_id = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    ansible_role = "frontend-docker"
    root_variable_size = 30
  }
  mongodb = {
    ami_id = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    root_variable_size = 20
  }
  catalogue = {
    ami_id = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    ansible_role = "catalogue-docker"
    root_variable_size = 30
  }
  redis = {
    ami_id        = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    root_variable_size = 20
  }
  cart = {
    ami_id        = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    ansible_role = "cart-docker"
    root_variable_size = 30
  }
  payment = {
    ami_id        = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    ansible_role = "payment-docker"
    root_variable_size = 30
  }
  shipping = {
    ami_id        = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    ansible_role = "shipping-docker"
    root_variable_size = 30
  }
  dispatch = {
    ami_id        = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    ansible_role = "dispatch-docker"
    root_variable_size = 30
  }
  rabbitmq = {
    ami_id        = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    root_variable_size = 20
  }
  mysql = {
    ami_id        = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    root_variable_size = 20
  }
  user = {
    ami_id        = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    ansible_role = "user-docker"
    root_variable_size = 30
  }
}



zone_id = "Z04349021DA1RQVNS1OQS"


vpc_security_group_ids = ["sg-0eba58b37f791d36a"]

env = "dev"