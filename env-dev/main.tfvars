instances = {
  frontend = {
    ami_id = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
  }
  mongodb = {
    ami_id = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
  }
  catalogue = {
    ami_id = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
  }
}



zone_id = "Z04349021DA1RQVNS1OQS"


vpc_security_group_ids = ["sg-0eba58b37f791d36a"]

env = "dev"