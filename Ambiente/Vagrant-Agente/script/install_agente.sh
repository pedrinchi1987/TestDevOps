#!/bin/bash
echo "CREANDO AGENTE DE AZURE DEVOPS"

#mkdir azagent;cd azagent;curl -fkSL -o vstsagent.tar.gz https://vstsagentpackage.azureedge.net/agent/3.242.1/vsts-agent-linux-x64-3.242.1.tar.gz;tar -zxvf vstsagent.tar.gz; if [ -x "$(command -v systemctl)" ]; then ./config.sh --deploymentpool --deploymentpoolname "DevsuPrueba-ServidorLocal" --acceptteeeula --agent $HOSTNAME --url https://dev.azure.com/pedrito1348/ --work _work --auth PAT --token {TOKEN_AZURE} --runasservice; sudo ./svc.sh install; sudo ./svc.sh start; else ./config.sh --deploymentpool --deploymentpoolname "DevsuPrueba-ServidorLocal" --acceptteeeula --agent $HOSTNAME --url https://dev.azure.com/pedrito1348/ --work _work --auth PAT --token {TOKEN_AZURE}; ./run.sh; fi

mkdir myagent && cd myagent
tar zxvf /vagrant_data/vsts-agent-linux-x64-3.242.1.tar.gz

#./config.sh <<EOF
#Y
#https://dev.azure.com/pedrito1348
#PAT
#TOKEN_AZURE

#PRMR

#EOF

#./run.sh

echo "FIN DE CREACION AGENTE DE AZURE DEVOPS"
