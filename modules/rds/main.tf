# Définition de la ressource pour l'instance de base de données RDS
resource "aws_db_instance" "default" {
  # Identifiant unique pour l'instance de base de données
  identifier           = var.db_identifier

  # Espace de stockage alloué en Go (le niveau gratuit autorise généralement jusqu'à 20 Go)
  allocated_storage    = var.allocated_storage

  # Type de stockage (gp2 est un type SSD à usage général)
  storage_type         = "gp2"

  # Moteur de base de données (ex: "mysql", "postgres")
  engine               = var.engine

  # Version du moteur de base de données
  engine_version       = var.engine_version

  # Classe d'instance (ex: "db.t3.micro" pour l'éligibilité au niveau gratuit)
  instance_class       = var.instance_class

  # Nom de la base de données initiale à créer
  db_name              = var.db_name

  # Nom d'utilisateur principal pour la base de données
  username             = var.db_username

  # Mot de passe pour l'utilisateur principal (sera stocké dans le state Terraform, envisagez d'utiliser AWS Secrets Manager pour la production)
  password             = var.db_password

  # Nom du groupe de paramètres de base de données à associer
  parameter_group_name = var.parameter_group_name

  # Ne pas créer de snapshot final lors de la suppression (souvent utilisé pour dev/test, à modifier pour la production)
  skip_final_snapshot  = true

  # Rendre l'instance accessible publiquement ou non (contrôle l'accès réseau)
  publicly_accessible  = var.publicly_accessible

  # Tags à appliquer à l'instance RDS
  tags = merge(
    var.tags, # Fusionne les tags passés en variable
    {
      # Ajoute un tag "Name" avec l'identifiant de la base de données
      Name = var.db_identifier
    }
  )
}
