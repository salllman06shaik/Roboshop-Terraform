db_instances = {
  mongodb = {
    ami_id = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    root_volume_size = 20
    subnet_ref = "db"
    port        = 27017
    app_cidr    = {
      app-subnet-1 = "10.200.4.0/24"
      app-subnet-2 = "10.200.5.0/24"
    }
  }
  redis = {
    ami_id        = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    root_volume_size = 20
    subnet_ref = "db"
    port        = 6379
    app_cidr    = {
      app-subnet-1 = "10.200.4.0/24"
      app-subnet-2 = "10.200.5.0/24"
    }
  }
  rabbitmq = {
    ami_id        = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    root_volume_size = 20
    subnet_ref = "db"
    port        = 5672
    app_cidr    = {
      app-subnet-1 = "10.200.4.0/24"
      app-subnet-2 = "10.200.5.0/24"
    }
  }
  mysql = {
    ami_id        = "ami-09c813fb71547fc4f"
    instance_type = "t3.small"
    root_volume_size = 20
    subnet_ref = "db"
    port        = 3306
    app_cidr    = {
      app-subnet-1 = "10.200.4.0/24"
      app-subnet-2 = "10.200.5.0/24"
    }
  }
  #frontend = {
  #  ami_id = "ami-09c813fb71547fc4f"
  #  instance_type = "t3.small"
  #  ansible_role = "frontend-docker"
  #  root_volume_size = 30
  #}
  #catalogue = {
  #  ami_id = "ami-09c813fb71547fc4f"
  #  instance_type = "t3.small"
  #  ansible_role = "catalogue-docker"
  #  root_volume_size = 30
  #}
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
        min_nodes = 1
        max_nodes = 10
        instance_types = ["t3.xlarge"]
        capacity_type = "SPOT"
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

vpc = {
  main = {
    cidr = "10.200.0.0/16"
    subnets = {
      public-subnet-1 = {
        cidr = "10.200.0.0/24"
        igw = true
        ngw = false
        zone = "us-east-1a"
        group = "public"
      }
      public-subnet-2 = {
        cidr = "10.200.1.0/24"
        igw = true
        ngw = false
        zone = "us-east-1b"
        group = "public"
      }
      db-subnet-1 = {
        cidr = "10.200.2.0/24"
        igw = false
        ngw = true
        zone = "us-east-1a"
        group = "db"
      }
      db-subnet-2 = {
        cidr = "10.200.3.0/24"
        igw = false
        ngw = true
        zone = "us-east-1b"
        group = "db"
      }
      app-subnet-1 = {
        cidr = "10.200.4.0/24"
        igw = false
        ngw = true
        zone = "us-east-1a"
        group = "app"
      }
      app-subnet-2 = {
        cidr = "10.200.5.0/24"
        igw = false
        ngw = true
        zone = "us-east-1b"
        group = "app"
      }
    }
  }
}

default_vpc = {
  vpc_id = "vpc-0979d32eb043b71fb"
  vpc_cidr = "172.31.0.0/16"
  routetable_id = "rtb-09a87eb57ec584752"
}

bastion_ssh_nodes = {
  workstation = "172.31.0.8/32"
  github_runner = "172.31.2.71/32"
}
