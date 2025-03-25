#!/bin/bash

sudo apt update
sudo apt install -y unzip
sudo apt install -y wget
sudo apt install -y curl

for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done


# Add Docker's official GPG key:
sudo mkdir -p -m 755 /etc/apt/keyrings
sudo apt update
sudo apt install -y ca-certificates curl 
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update


$(. /etc/os-release && echo "$VERSION_CODENAME")

sudo apt-get install -y containerd.io docker-ce docker-ce-cli
sudo usermod -aG docker $USER

newgrp docker

#Instalando k8s
#DOC: https://v1-31.docs.kubernetes.io/pt-br/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
sudo apt-get update
# apt-transport-https pode ser um pacote fictício; se for, você pode pular esse pacote
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# Se o diretório `/etc/apt/keyrings` não existir, ele deve ser criado antes do comando curl, leia a nota abaixo.

sudo rm -rf /etc/apt/keyrings/kubernetes-apt-keyring.gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Isso sobrescreve qualquer configuração existente em /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl enable --now kubelet