# Variables pour la configuration de l'infrastructure

variable "aws_region" {
  description = "Région AWS à utiliser"
  type        = string
  default     = "eu-west-3"
}

variable "instance_type" {
  description = "Type d'instance EC2"
  type        = string
  default     = "t2.micro"
}

variable "environment" {
  description = "Environnement (dev, prod, etc.)"
  type        = string
  default     = "dev"
} 