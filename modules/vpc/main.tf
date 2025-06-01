resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env}-${var.name}"
  }
}

resource "aws_subnet" "main" {
  for_each   = var.subnets
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value["cidr"]

  tags = {
    Name = each.key
  }
}


resource "aws_vpc_peering_connection" "peer-to-default-vpc" {
  peer_owner_id = data.aws_caller_identity.current.account_id
  peer_vpc_id   = aws_vpc.main.id
  vpc_id        = var.default_vpc["vpc_id"]
}