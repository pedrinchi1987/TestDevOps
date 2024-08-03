#!/bin/bash

echo "INICIO CONFIGURACION INICIAL"

sudo apt install net-tools
sudo apt-get curl -y
sudo apt-get install software-properties-common gnupg2 -y
sudo curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main" <<EOF

EOF
sudo apt-get update -y
sudo apt-get install terraform -y

sudo terraform --version

echo "FIN CONFIGURACION INICIAL"
