locals {
  puertos_accesibles_in = ["80", "443", "22", "3306", "3307"]
  ami_code              = "ami-04a81a99f5ec58529" # "ami-00beae93a2d981137"
  instance_type         = "t2.micro"              # "t3.medium"             # 
  max_price             = 0.015                   # 0.005
  uso_spot              = false
}
