db_instances = {
  #frontend = {
  #  ami_id = "ami-09c813fb71547fc4f"
  #  instance_type = "t3.small"
  #  ansible_role = "frontend-docker"
  #  root_volume_size = 30
  #}
  mongodb = {
    ami_id = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    root_volume_size = 20
  }
  #catalogue = {
  #  ami_id = "ami-09c813fb71547fc4f"
  #  instance_type = "t3.small"
  #  ansible_role = "catalogue-docker"
  #  root_volume_size = 30
  #}
  redis = {
    ami_id        = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    root_volume_size = 20
  }
  #cart = {
  #  ami_id        = "ami-09c813fb71547fc4f"
  #  instance_type = "t3.small"
  #  ansible_role = "cart-docker"
  #  root_volume_size = 30
  #}
  #payment = {
  #  ami_id        = "ami-09c813fb71547fc4f"
  #  instance_type = "t3.small"
  #  ansible_role = "payment-docker"
  #  root_volume_size = 30
  #}
  #shipping = {
  #  ami_id        = "ami-09c813fb71547fc4f"
  #  instance_type = "t3.small"
  #  ansible_role = "shipping-docker"
  #  root_volume_size = 30
  #}
  #dispatch = {
  #  ami_id        = "ami-09c813fb71547fc4f"
  #  instance_type = "t3.small"
  #  ansible_role = "dispatch-docker"
  #  root_volume_size = 30
  #}
  rabbitmq = {
    ami_id        = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    root_volume_size = 20
  }
  mysql = {
    ami_id        = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    root_volume_size = 20
  }
  #user = {
  #  ami_id        = "ami-09c813fb71547fc4f"
  #  instance_type = "t3.small"
  #  ansible_role = "user-docker"
  #  root_volume_size = 30
  #}
}



zone_id = "Z04349021DA1RQVNS1OQS"


vpc_security_group_ids = ["sg-0eba58b37f791d36a"]

env = "dev"


eks = {
  main = {
    subnets = ["subnet-0f46cbdb51edf8fff","subnet-0bb0e5e3171a985ae"]
    eks_version = 1.32
    node_groups = {
      main = {
        min_nodes = 3
        max_nodes = 10
        instance_types = ["t3.medium" , "t3.large"]
      }
    }

    addons = {
      #metrics-server = {}
      eks-pod-identity-agent = {}
    }

    access = {
      workstation = {
        role                    = "arn:aws:iam::533267148162:role/workstation-role"
        kubernetes_groups       = []
        policy_arn              = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        access_scope_type       = "cluster"
        access_scope_namespaces = []
      }
    }
  }
}