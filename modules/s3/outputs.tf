# Sorties du module S3 - Informations importantes à récupérer

# ID du bucket S3 créé
# Utilisé pour les références dans d'autres ressources ou pour la gestion
output "bucket_id" {
  description = "ID du bucket S3"
  value       = aws_s3_bucket.bucket.id
}

# ARN (Amazon Resource Name) du bucket S3
# Utilisé pour les politiques IAM et les références croisées
output "bucket_arn" {
  description = "ARN du bucket S3"
  value       = aws_s3_bucket.bucket.arn
} 