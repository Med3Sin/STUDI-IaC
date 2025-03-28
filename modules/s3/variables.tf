# Variables du module S3 - Configuration des paramètres du bucket S3

# Nom de base du bucket S3
# Un suffixe aléatoire sera ajouté pour garantir l'unicité
variable "bucket_name" {
  description = "Nom de base du bucket S3"
  type        = string
}

# Tags à appliquer au bucket S3
# Permet d'ajouter des métadonnées pour une meilleure organisation
# et la gestion des coûts
variable "tags" {
  description = "Tags à appliquer aux ressources"
  type        = map(string)
  default     = {}
} 