# Variables du module EC2 - Configuration des paramètres de l'instance EC2

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
