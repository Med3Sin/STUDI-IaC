# Sorties du module EC2 - Informations importantes à récupérer

# ID de l'instance EC2 créée
# Utile pour les références dans d'autres ressources ou pour la gestion
output "instance_id" {
  description = "ID de l'instance EC2"
  value       = aws_instance.instance.id
}

# IP publique de l'instance EC2
# Nécessaire pour accéder à l'instance via SSH ou pour l'application web
output "public_ip" {
  description = "IP publique de l'instance EC2"
  value       = aws_instance.instance.public_ip
}

# ID du groupe de sécurité créé
# Utile pour ajouter des règles de sécurité supplémentaires ou pour la gestion
output "security_group_id" {
  description = "ID du groupe de sécurité"
  value       = aws_security_group.security_group.id
} 