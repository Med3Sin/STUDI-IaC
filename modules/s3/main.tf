# Module S3 - Configuration du bucket S3 et de ses paramètres de sécurité

# Création du bucket S3 principal
resource "aws_s3_bucket" "bucket" {
  # Nom du bucket : combinaison du nom de base et d'un suffixe aléatoire
  # pour garantir l'unicité du nom
  bucket = "${var.bucket_name}-${random_id.bucket_suffix.hex}"

  # Application des tags directement sur le bucket
  tags = var.tags
}

# Génération d'un suffixe aléatoire pour le nom du bucket
# Utilise 4 bytes (8 caractères hexadécimaux) pour l'unicité
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Configuration des paramètres de sécurité du bucket S3
# Bloque tout accès public au bucket
resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  # Bloque les ACLs publics
  block_public_acls       = true
  # Bloque les politiques publiques
  block_public_policy     = true
  # Ignore les ACLs publics existants
  ignore_public_acls      = true
  # Restreint l'accès public au bucket
  restrict_public_buckets = true
} 