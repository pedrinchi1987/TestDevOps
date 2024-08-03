#!/bin/bash

echo "INSTALACION COMPONENTES CONTENEDORES"

user=$(whoami)
echo "---------------- DOCKER ---------------------"
sudo apt-get update && sudo apt-get install docker.io -y
sudo groupadd docker
sudo usermod -aG docker $user

echo "---------------- KUBECTL ---------------------"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
sudo install -o $user -g $user -m 0755 kubectl /usr/local/bin/kubectl

sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo apt-get install -y apt-transport-https
#sudo apt-get install -y kubectl

echo "---------------- MINIKUBE ---------------------"
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

newgrp docker

#ESTOS COMANDOS HAY QUE EJECUTARLOS A MANO POSTERIOR A LA EJECUCION DE ESTE SCRIPT
#minikube start --extra-config=apiserver.service-node-port-range=5000-32767 --force

echo "FIN COMPONENTES CONTENEDORES"

