#!/bin/bash

echo "Actualizar"
sudo apt update && apt upgrade

echo "Instalando node.js"
sudo apt install nodejs -y

echo "Instalando npm"
sudo apt install npm -y

echo "Clonando repositorio"
git clone https://github.com/sarang3232/consulService
cd consulService/app && sudo npm install consul express
cd ../..

echo "Instalando Consul"
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install consul

echo "Iniciando agente Consul"
sudo touch consulagent
sudo echo "#!/bin/bash" >> consulagent
sudo echo "# -*- ENCODING: UTF-8 -*-" >> consulagent
sudo echo "consul agent -ui -server -data-dir=. -node=agent-two -bind=192.168.100.5 -client=0.0.0.0 -enable-script-checks=true -config-dir=/etc/consul.d -retry-join "192.168.100.3"" >> consulagent
sudo chmod +x consulagent

cd /etc/systemd/system
sudo touch consul.service
sudo echo "[Unit]" >> consul.service
sudo echo "Description=Running consul agent" >> consul.service
sudo echo "[Service]" >> consul.service
sudo echo "User=root" >> consul.service
sudo echo "ExecStart=/home/vagrant/consulagent" >> consul.service
sudo echo "[Install]" >> consul.service
sudo echo "WantedBy=multi-user.target" >> consul.service
sudo chmod 777 consul.service

sudo systemctl daemon-reload
sudo systemctl enable consul.service
sudo systemctl restart consul.service

echo "Lanzando pagina"
cd ../../..
cd home/vagrant/
cd consulService/app
node index.js 2000 &
