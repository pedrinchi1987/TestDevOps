#!/bin/bash

echo "INICIO CONFIGURACION TERRAFORM"

terraform --version

json='{
  "credentials": {
    "app.terraform.io": {
      "token": "{TOKEN_TERRAFORM}"
    }
  }
}'

sudo echo -e $json > /home/vagrant/.terraform.d/credentials.tfrc.json

echo "FIN CONFIGURACION TERRAFORM"
