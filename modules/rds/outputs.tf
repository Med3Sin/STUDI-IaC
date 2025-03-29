output "db_instance_address" {
  description = "L'adresse (endpoint) de l'instance de base de données RDS."
  value       = aws_db_instance.default.address
}

output "db_instance_port" {
  description = "Le port sur lequel l'instance de base de données RDS écoute."
  value       = aws_db_instance.default.port
}

output "db_instance_arn" {
  description = "L'ARN (Amazon Resource Name) de l'instance de base de données RDS."
  value       = aws_db_instance.default.arn
}

output "db_instance_name" {
  description = "Le nom de la base de données (DB Name) de l'instance RDS."
  value       = aws_db_instance.default.db_name
}
