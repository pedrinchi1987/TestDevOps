#CREACION DE INSTANCIAS PRUEBA
/*
resource "aws_instance" "instancia_1" {
  ami                         = data.aws_ami.select_ami_ec2.id
  instance_type               = "t2.micro"
  subnet_id                   = var.habilitar_publica ? aws_subnet.red_publica[0].id : aws_subnet.red_privada.id
  security_groups             = [aws_security_group.sg_instancias.id]
  associate_public_ip_address = var.habilitar_publica
  user_data                   = <<-EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum -y install httpd -y
  sudo service httpd start
  sudo chmod 777 /var/www/html/
  sudo echo "Hello world from EC2 $(hostname -f)" > /var/www/html/index.html
  EOF

  tags = {
    Name     = "ec2-${var.env}-instancia-1-prmr"
    Ambiente = upper(var.env)
  }
}
*/


#CREACION DE INSTANCIA CON PLANTILLA
resource "aws_instance" "instancias" {
  count         = var.cantidad_instancias
  instance_type = local.instance_type
  key_name      = data.aws_key_pair.claves.key_name

  launch_template {
    id = aws_launch_template.plantilla_instancia_web.id

    # Use the latest version of the launch template
    version = "$Latest"
  }

  tags = {
    Name     = "ec2-${var.env}-instancia-${count.index}-prmr"
    Ambiente = upper(var.env)
  }

  depends_on = [
    aws_launch_template.plantilla_instancia_web
  ]
}

/*
#CREACION DE BALANCEADORES DE CARGA (ALB)
resource "aws_lb_target_group" "tg_balanceador_1" {
  name        = "tg-${var.env}-balanceador-prmr"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc_principal.id

  tags = {
    Name     = "tg-${var.env}-balanceador-prmr"
    Ambiente = upper(var.env)
  }

  depends_on = [aws_vpc.vpc_principal]
}

resource "aws_lb_target_group_attachment" "tg_asociacion" {
  count            = var.cantidad_instancias
  target_group_arn = aws_lb_target_group.tg_balanceador_1.arn
  target_id        = aws_instance.instancias[count.index].id
  port             = 80

  depends_on = [aws_lb_target_group.tg_balanceador_1]
}

resource "aws_lb" "balanceador_web" {
  name               = "lb-${var.env}-balanceador-prmr"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_instancias.id]
  subnets            = var.habilitar_publica ? aws_subnet.red_publica[*].id : aws_subnet.red_privada[*].id

  tags = {
    Name     = "lb-${var.env}-balanceador-prmr"
    Ambiente = upper(var.env)
  }

  depends_on = [
    aws_subnet.red_privada,
    aws_subnet.red_publica,
    aws_security_group.sg_instancias
  ]
}

resource "aws_lb_listener" "listener_balanceador" {
  load_balancer_arn = aws_lb.balanceador_web.arn
  port              = "80"
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_balanceador_1.arn
  }

  depends_on = [
    aws_lb_target_group.tg_balanceador_1,
    aws_lb_target_group_attachment.tg_asociacion
  ]
}

resource "aws_lb_listener_rule" "listener_regla_1" {
  listener_arn = aws_lb_listener.listener_balanceador.arn
  priority     = 100

  action {
    type = "redirect"

    redirect {
      host        = "www.google.com.ec"
      path        = "/"
      port        = "443"
      status_code = "HTTP_301"
    }
  }

  condition {
    path_pattern {
      values = ["/static/*"]
    }
  }

  tags = {
    Name     = "lblr-${var.env}-regla-listener-prmr"
    Ambiente = upper(var.env)
  }
}
*/

/*
#CREACION DE BALANCEADORES DE CARGA (NLB)
#PRUEBA MYSQL
resource "aws_lb_target_group" "tg_balanceador_2" {
  count       = var.cantidad_instancias > 1 ? 1 : 0
  name        = "tg-${var.env}-balanceador-mysql-1-prmr"
  port        = 3306
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc_principal.id

  tags = {
    Name     = "tg-${var.env}-balanceador-mysql-1-prmr"
    Ambiente = upper(var.env)
  }

  depends_on = [aws_vpc.vpc_principal]
}


resource "aws_lb_target_group_attachment" "tg_asociacion_mysql_1" {
  count            = var.cantidad_instancias > 1 ? 1 : 0
  target_group_arn = aws_lb_target_group.tg_balanceador_2[0].arn
  target_id        = aws_instance.instancias[0].id
  port             = 3306

  depends_on = [aws_lb_target_group.tg_balanceador_2]
}


resource "aws_lb_target_group" "tg_balanceador_3" {
  count       = var.cantidad_instancias > 2 ? 1 : 0
  name        = "tg-${var.env}-balanceador-mysql-2-prmr"
  port        = 3306
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc_principal.id

  tags = {
    Name     = "tg-${var.env}-balanceador-mysql-2-prmr"
    Ambiente = upper(var.env)
  }

  depends_on = [aws_vpc.vpc_principal]
}


resource "aws_lb_target_group_attachment" "tg_asociacion_mysql_2" {
  count            = var.cantidad_instancias > 2 ? 1 : 0
  target_group_arn = aws_lb_target_group.tg_balanceador_3[0].arn
  target_id        = aws_instance.instancias[1].id
  port             = 3306

  depends_on = [aws_lb_target_group.tg_balanceador_3]
}

resource "aws_lb" "balanceador_mysql" {
  name               = "lb-${var.env}-balanceador-mysql-prmr"
  load_balancer_type = "network"
  security_groups    = [aws_security_group.sg_instancias.id]
  subnets            = var.habilitar_publica ? aws_subnet.red_publica[*].id : aws_subnet.red_privada[*].id

  tags = {
    Name     = "lb-${var.env}-balanceador-mysql-prmr"
    Ambiente = upper(var.env)
  }

  depends_on = [
    aws_subnet.red_privada,
    aws_subnet.red_publica,
    aws_security_group.sg_instancias
  ]
}

resource "aws_lb_listener" "listener_balanceador_mysql_1" {  
  count       = var.cantidad_instancias > 1 ? 1 : 0
  load_balancer_arn = aws_lb.balanceador_mysql.arn
  port              = "3306"
  protocol          = "TCP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_balanceador_2[0].arn
  }

  depends_on = [
    aws_lb_target_group.tg_balanceador_2,
    aws_lb_target_group_attachment.tg_asociacion_mysql_1
  ]
}

resource "aws_lb_listener" "listener_balanceador_mysql_2" {  
  count       = var.cantidad_instancias > 2 ? 1 : 0
  load_balancer_arn = aws_lb.balanceador_mysql.arn
  port              = "3307"
  protocol          = "TCP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_balanceador_3[0].arn
  }

  depends_on = [
    aws_lb_target_group.tg_balanceador_3,
    aws_lb_target_group_attachment.tg_asociacion_mysql_2
  ]
}
*/
