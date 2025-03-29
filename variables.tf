# Variables pour la configuration de l'infrastructure

variable "aws_region" {
  description = "Région AWS à utiliser"
  type        = string
  default     = "eu-west-3" # Paris
}

variable "db_username" {
  description = "Nom d'utilisateur principal pour la base de données RDS."
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Mot de passe pour l'utilisateur principal de la base de données RDS."
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Nom de la base de données initiale dans l'instance RDS."
  type        = string
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
