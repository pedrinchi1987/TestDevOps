data "aws_availability_zones" "zona_habilitada" {
  state = "available"
}

data "aws_ami" "select_ami_ec2" {
  owners = ["amazon"]
  filter {
    name   = "image-id"
    values = [local.ami_code]
  }
}

data "aws_key_pair" "claves" {
  key_name = "acceso-servidores"
}

