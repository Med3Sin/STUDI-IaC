# Variables du module EC2 - Configuration des paramètres de l'instance EC2

# ID de l'AMI (Amazon Machine Image) à utiliser pour l'instance
# Par défaut, utilise Amazon Linux 2 AMI dans la région eu-west-3 (Paris)
variable "ami_id" {
  description = "ID de l'AMI à utiliser"
  type        = string
  default     = "ami-06903a0d7dc8effb5"  # Amazon Linux 2 AMI
}

# Type d'instance EC2 à utiliser
# t2.micro est le plus petit type d'instance, gratuit dans le tier gratuit AWS
variable "instance_type" {
  description = "Type d'instance EC2"
  type        = string
  default     = "t2.micro"
}

# Nom de l'instance EC2
# Utilisé pour le tag Name et pour générer le nom du groupe de sécurité
variable "instance_name" {
  description = "Nom de l'instance EC2"
  type        = string
}

# Tags à appliquer aux ressources créées par ce module
# Permet d'ajouter des métadonnées pour une meilleure organisation
variable "tags" {
  description = "Tags à appliquer aux ressources"
  type        = map(string)
  default     = {}
} 