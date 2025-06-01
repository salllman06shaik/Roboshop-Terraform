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
  auto_accept   = true
}

resource "aws_route" "in-main" {
  count                     = length(local.all_route_table_ids)
  route_table_id                     = var.default_vpc["routetable_id"]
  destination_cidr_block    = var.default_vpc["vpc_cidr"]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer-to-default-vpc.id
}

resource "aws_route" "in-default" {
  route_table_id                     = var.default_vpc["routetable_id"]
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer-to-default-vpc.id
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.env}-${var.name}"
  }
}

resource "aws_eip" "ngw" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.ngw.id
  subnet_id     = aws_subnet.main["default"].id

  tags = {
    Name = "${var.env}-${var.name}"
  }
}