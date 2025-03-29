# Configuration du provider AWS
provider "aws" {
  region = var.aws_region
}

# Module EC2
module "ec2" {
  source = "./modules/ec2"

  instance_name = "server-java-${var.environment}"
  instance_type = var.instance_type
  tags = {
    Environment = var.environment
    Project     = "Java-Tomcat-Server"
  }
}

# Module S3
module "s3" {
  source = "./modules/s3"

  bucket_name = "bucket-${var.environment}"
  tags = {
    Environment = var.environment
    Project     = "Java-Tomcat-Server"
  }
}

# Module RDS
module "rds" {
  source = "./modules/rds"

  db_identifier = "mydb-${var.environment}" # Identifiant unique pour la DB
  engine        = "mysql"                   # Moteur de base de données
  engine_version = "8.0"                    # Version spécifique de MySQL (vérifier les versions éligibles au free tier)
  # instance_class = "db.t3.micro"          # Déjà défini par défaut dans le module
  # allocated_storage = 20                   # Déjà défini par défaut dans le module
  db_name       = var.db_name               # Utilise la variable racine
  db_username   = var.db_username           # Utilise la variable racine
  db_password   = var.db_password           # Utilise la variable racine
  # publicly_accessible = false              # Déjà défini par défaut dans le module

  tags = {
    Environment = var.environment
    Project     = "Java-Tomcat-Server"
  }
}

# Affichage des informations importantes
output "bucket_name" {
  value = module.s3.bucket_id
}

output "instance_public_ip" {
  value = module.ec2.public_ip
}

output "db_instance_address" {
  description = "Adresse de l'instance RDS"
  value       = module.rds.db_instance_address
}

output "db_instance_name" {
  description = "Nom de la base de données RDS"
  value       = module.rds.db_instance_name
}
