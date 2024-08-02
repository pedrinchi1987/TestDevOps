#CREACION DE VPC
resource "aws_vpc" "vpc_principal" {
  cidr_block       = "66.66.0.0/26"
  instance_tenancy = "default"

  tags = {
    Name     = "vpc-${var.env}-principal-prmr"
    Ambiente = upper(var.env)
  }
}

#CREACION DE REDES
resource "aws_subnet" "red_privada" {
  count             = var.cantidad_zonas
  vpc_id            = aws_vpc.vpc_principal.id
  availability_zone = data.aws_availability_zones.zona_habilitada.names[count.index]
  cidr_block        = "66.66.0.${0 + (count.index * 16)}/28"

  tags = {
    Name     = "net-${var.env}-private-${count.index}-prmr"
    Ambiente = upper(var.env)
  }

  depends_on = [aws_vpc.vpc_principal]
}

resource "aws_subnet" "red_publica" {
  count             = var.habilitar_publica ? var.cantidad_zonas : 0
  vpc_id            = aws_vpc.vpc_principal.id
  availability_zone = data.aws_availability_zones.zona_habilitada.names[count.index]
  cidr_block        = "66.66.0.${(var.cantidad_zonas * 16) + (count.index * 16)}/28"

  tags = {
    Name     = "net-${var.env}-public-${count.index}-prmr"
    Ambiente = upper(var.env)
  }

  depends_on = [aws_vpc.vpc_principal]
}

#CREACION DE INTERNET GATEWAY
resource "aws_internet_gateway" "ig_red_publica" {
  count  = var.habilitar_publica ? 1 : 0
  vpc_id = aws_vpc.vpc_principal.id

  tags = {
    Name     = "igw-${var.env}-salida-net-prmr"
    Ambiente = upper(var.env)
  }

  depends_on = [aws_vpc.vpc_principal]
}

#CREACION DE TABLAS DE RUTAS
resource "aws_route_table" "tabla_ruta_red_publica" {
  count  = var.habilitar_publica ? 1 : 0
  vpc_id = aws_vpc.vpc_principal.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig_red_publica[0].id
  }

  tags = {
    Name     = "rt-${var.env}-ruta-net-prmr"
    Ambiente = upper(var.env)
  }

  depends_on = [
    aws_vpc.vpc_principal,
    aws_internet_gateway.ig_red_publica
  ]
}

resource "aws_route_table_association" "asociacion_ruta_publica" {
  count          = var.habilitar_publica ? 1 : 0
  route_table_id = aws_route_table.tabla_ruta_red_publica[0].id
  subnet_id      = aws_subnet.red_publica[0].id

  depends_on = [
    aws_subnet.red_publica,
    aws_route_table.tabla_ruta_red_publica
  ]
}

#CREACION DE GRUPOS DE SEGURIDAD
resource "aws_security_group" "sg_instancias" {
  name        = "sgr-${var.env}-seguridad-instancias-prmr"
  description = "Grupo de Seguridad para las instancias"
  vpc_id      = aws_vpc.vpc_principal.id

  tags = {
    Name     = "sgr-${var.env}-seguridad-instancias-prmr"
    Ambiente = upper(var.env)
  }

  depends_on = [aws_vpc.vpc_principal]
}


resource "aws_vpc_security_group_ingress_rule" "regla_ingreso" {
  for_each          = toset(local.puertos_accesibles_in)
  security_group_id = aws_security_group.sg_instancias.id
  from_port         = each.key
  to_port           = each.key
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  depends_on = [aws_security_group.sg_instancias]
}

/*
resource "aws_vpc_security_group_ingress_rule" "regla_ingreso_1" {
  security_group_id = aws_security_group.sg_instancias.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  depends_on = [aws_security_group.sg_instancias]
}

resource "aws_vpc_security_group_ingress_rule" "regla_ingreso_2" {
  security_group_id = aws_security_group.sg_instancias.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  depends_on = [aws_security_group.sg_instancias]
}

resource "aws_vpc_security_group_ingress_rule" "regla_ingreso_3" {
  security_group_id = aws_security_group.sg_instancias.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  depends_on = [aws_security_group.sg_instancias]
}

resource "aws_vpc_security_group_ingress_rule" "regla_ingreso_4" {
  security_group_id = aws_security_group.sg_instancias.id
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  depends_on = [aws_security_group.sg_instancias]
}
*/

resource "aws_vpc_security_group_egress_rule" "regla_egreso_1" {
  security_group_id = aws_security_group.sg_instancias.id
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  depends_on = [aws_security_group.sg_instancias]
}

resource "aws_default_network_acl" "default_acl" {
  default_network_acl_id = aws_vpc.vpc_principal.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name     = "nac-${var.env}-default-acl-prmr"
    Ambiente = upper(var.env)
  }

  depends_on = [aws_vpc.vpc_principal]
}

resource "aws_default_route_table" "default_rt" {
  default_route_table_id = aws_vpc.vpc_principal.default_route_table_id

  tags = {
    Name     = "rt-${var.env}-default-rt-prmr"
    Ambiente = upper(var.env)
  }

  depends_on = [aws_vpc.vpc_principal]
}
