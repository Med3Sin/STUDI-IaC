variable "db_identifier" {
  description = "Identifiant unique pour l'instance RDS."
  type        = string
}

variable "allocated_storage" {
  description = "Espace de stockage alloué en Go."
  type        = number
  default     = 20 # Taille par défaut pour le niveau gratuit
}

variable "engine" {
  description = "Moteur de base de données (ex: mysql, postgres)."
  type        = string
}

variable "engine_version" {
  description = "Version du moteur de base de données."
  type        = string
}

variable "instance_class" {
  description = "Classe d'instance RDS (ex: db.t3.micro)."
  type        = string
  default     = "db.t3.micro" # Classe éligible au niveau gratuit
}

variable "db_name" {
  description = "Nom de la base de données initiale."
  type        = string
}

variable "db_username" {
  description = "Nom d'utilisateur principal pour la base de données."
  type        = string
}

variable "db_password" {
  description = "Mot de passe pour l'utilisateur principal."
  type        = string
  sensitive   = true # Marque cette variable comme sensible
}

variable "parameter_group_name" {
  description = "Nom du groupe de paramètres de base de données."
  type        = string
  default     = null # Utilise le groupe par défaut si non spécifié
}

variable "publicly_accessible" {
  description = "Indique si l'instance doit être accessible publiquement."
  type        = bool
  default     = false # Par défaut, non accessible publiquement pour la sécurité
}

variable "tags" {
  description = "Tags à appliquer à l'instance RDS."
  type        = map(string)
  default     = {}
}
