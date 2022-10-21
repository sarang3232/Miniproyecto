#!/bin/bash

echo "Instalar haproxy"
sudo apt update && apt upgrade
sudo apt install haproxy -y
sudo systemctl enable haproxy 

echo "cargando página de error"
sudo cp --force /vagrant/503.http /etc/haproxy/errors/503.http

echo "Clonando repositorio"
git clone https://github.com/sarang3232/CompNubeStiven
cd CompNubeStiven/ && sudo mv haproxy.cfg /etc/haproxy/haproxy.cfg
cd

echo "Iniciar HAProxy"
sudo systemctl start haproxy
sudo systemctl restart haproxy


