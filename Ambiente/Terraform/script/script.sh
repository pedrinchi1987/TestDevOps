#!/bin/bash

sudo yum update -y
sudo yum -y install httpd -y
sudo service httpd start
sudo chmod 777 /var/www/html/
sudo echo "Hello world from EC2 $(hostname -f)" > /var/www/html/index.html

sudo dnf update
sudo dnf install mariadb105-server -y
sudo systemctl start mariadb
sudo systemctl enable mariadb
#sudo systemctl status mariadb
sudo mysql_secure_installation <<EOF

Y
Y
123
123
Y
Y
Y
Y
EOF


#sudo dnf install mariadb105 -y
#sudo yum install mariadb -y
#sudo yum install mariadb-server -y


comandos="create user 'user1'@'%' identified by 'user1';grant all on *.* to 'user1'@'%';exit;"
echo "${comandos}" | mysql -u root -p --password=123

#mysql -u user1 -p --password=user1 -h 


sudo apt-get update && sudo apt-get install docker.io -y
sudo groupadd docker
sudo usermod -aG docker root
sudo usermod -aG docker ubuntu
newgrp docker

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
sudo install -o ubuntu -g ubuntu -m 0755 kubectl /usr/local/bin/kubectl

sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo apt-get install -y apt-transport-https

sudo apt-get install -y kubectl

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

minikube start
