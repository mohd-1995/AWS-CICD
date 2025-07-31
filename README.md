# AWS-CICD
CI/CD Three-Tier Web Application Project:
ssh -i /apth to key pair/keypair.pem -L 8080:localhost:8080 ubuntu@ip-address


DEV --> GitHub --> GitHub Actions --> DockerHub
                                 ↘︎   (Security Scans)
                                  ↘︎ Push K8s YAML → Git Repo (Manifests)
                                                         ↘︎
                                                ArgoCD (on EC2) → Kubernetes
                                                                     ↘︎
                                                             AWS ALB + Route53
                                                                     ↘︎
                                                              Live 3-tier App
