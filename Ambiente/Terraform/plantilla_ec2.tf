#CREACION DE PLANTILLA
resource "aws_launch_template" "plantilla_instancia_web" {
  name          = "pl-${var.env}-instancia-prmr"
  image_id      = data.aws_ami.select_ami_ec2.id
  instance_type = local.instance_type
  key_name      = data.aws_key_pair.claves.key_name

  network_interfaces {
    subnet_id                   = var.habilitar_publica ? aws_subnet.red_publica[0].id : aws_subnet.red_privada[0].id
    security_groups             = [aws_security_group.sg_instancias.id]
    associate_public_ip_address = var.habilitar_publica
  }

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = local.max_price
    }
  }

  user_data = filebase64("${path.module}/script/script.sh")

  tags = {
    Name     = "pl-${var.env}-instancia-prmr"
    Ambiente = upper(var.env)
  }

  depends_on = [
    aws_subnet.red_publica,
    aws_subnet.red_privada,
    aws_security_group.sg_instancias
  ]
}
