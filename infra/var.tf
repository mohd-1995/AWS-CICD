variable "vpc-name" {
  default = "myvpc"
}

variable "igw-name" {
  default = "igw-for-aws"
}

variable "subnet-name" {
  default = "my-aws-subnet-for-CICD"
}

variable "rt-name" {
  default = "route-table-CICD"
}

variable "sg1-name" {
  default = "sg1-for-CICD"
}

variable "iam-role-name" {
  default = "role-for-CICD-access"
}

variable "iam-policy-arn" {
  default = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


variable "ami" {
  default = "ami-044415bb13eee2391"
}

variable "instancetype" {
  default = "t3.medium"
}

variable "keyname" {
  default = "moe-keypair"
}

variable "ec2" {
  default = "CICD-ec2"
}

