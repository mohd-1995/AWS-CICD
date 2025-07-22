#!/bin/bash
# For Ubuntu 22.04


#exit my scripts upon the first error
#set -e 
echo "Starting initialization script..."


#logs all outputs to file
sudo bash -c 'exec >> /var/log/init-script.log 2>&1'

#updating the system
# Update the operating system and install Docker

sudo apt list 

sudo apt list --upgradable
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
docker --version
sudo usermod -aG docker ubuntu
sudo systemctl enable --now docker 


#Wait for docker to initialize 
sleep 20


#installing the amazon cli
# 1. Ensure required packages are installed
sudo apt list --upgradable
sudo apt install -y unzip curl
cd /tmp
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip -o awscliv2.zip
sudo ./aws/install
aws --version

#installing kubectl
#sudo apt install curl -y
sudo curl -LO "https://dl.k8s.io/release/v1.33.0/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin
kubectl version --client
aws eks update-kubeconfig --region eu-west-2 --name my-cluster


# Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

# Install Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo snap install terraform --classic
terraform --version


# Install Trivy
#sudo apt-get install wget gnupg
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy
trivy --version


#aws eks update-kubeconfig --region us-east-1 --name my-cluster
