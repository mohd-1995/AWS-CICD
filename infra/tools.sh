#!/bin/bash
# For Ubuntu 22.04


#exit my scripts upon the first error
set -e 
echo "Starting initialization script..."


#logs all outputs to file
sudo bash -c 'exec >> /var/log/init-script.log 2>&1'

#updating the system
# Update the operating system and install Docker
sudo apt-get update -y
sudo apt-get upgrade -y

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
sudo ./aws/install --update
aws --version

# Install kubectl (latest stable)
curl -sfL https://get.k3s.io | sh -
# Export kubeconfig so it's usable immediately
mkdir -p /home/ubuntu/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/ubuntu/.kube/config
sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config
export KUBECONFIG=/home/ubuntu/.kube/config

# Allow kubectl commands for ubuntu user by default
echo 'export KUBECONFIG=/home/ubuntu/.kube/config' >> /home/ubuntu/.bashrc


#installing kubectl
#sudo apt install curl -y
sudo curl -LO "https://dl.k8s.io/release/v1.33.0/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin
kubectl create namespace my-sre
kubectl version --client


# Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

# Install Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo snap install terraform --classic
terraform --version


# Install Trivy
sudo apt-get install wget gnupg
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update -y
sudo apt-get install -y trivy
trivy --version


# Install Argo CD with Kubectl
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.4.7/manifests/install.yaml
sudo apt install jq -y

# Installing Helm
sudo snap install helm --classic

# Adding Helm repositories

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Install Prometheus
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace

# Install Grafkana
helm install grafana grafana/grafana --namespace monitoring --create-namespace

# Install ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx

echo "Initialization script completed successfully."


