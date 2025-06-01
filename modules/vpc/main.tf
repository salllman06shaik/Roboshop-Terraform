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