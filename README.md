# Infrastructure Cloud Java-Tomcat avec Terraform

Ce projet crée une infrastructure cloud sur AWS avec une instance EC2 (serveur Java/Tomcat) et un bucket S3 pour le stockage. Le code est organisé en modules pour une meilleure réutilisabilité et maintenance.

## Architecture

```
.
├── main.tf                 # Configuration principale et utilisation des modules
├── variables.tf           # Variables globales du projet
├── README.md             # Documentation du projet
└── modules/
    ├── ec2/              # Module pour l'instance EC2
    │   ├── main.tf       # Configuration de l'instance EC2 et du groupe de sécurité
    │   ├── variables.tf  # Variables spécifiques au module EC2
    │   └── outputs.tf    # Sorties du module EC2
    └── s3/               # Module pour le bucket S3
        ├── main.tf       # Configuration du bucket S3
        ├── variables.tf  # Variables spécifiques au module S3
        └── outputs.tf    # Sorties du module S3
```

## Composants

### Instance EC2
- Amazon Linux 2 comme système d'exploitation
- Java 11 (Amazon Corretto) installé
- Tomcat 9 installé et configuré
- Groupe de sécurité avec règles pour SSH (port 22) et Tomcat (port 8080)

### Bucket S3
- Nom unique généré automatiquement
- Configuration sécurisée (accès public bloqué)
- Support des tags pour une meilleure organisation

## Prérequis

1. Installer [Terraform](https://www.terraform.io/downloads.html) (version 0.12 ou supérieure)
2. Avoir un compte AWS avec des credentials configurés
3. Avoir les droits nécessaires pour créer des ressources AWS

## Free Tier AWS

Cette infrastructure est compatible avec le Free Tier AWS avec les limitations suivantes :

### Ressources Gratuites (par mois)
- **EC2** :
  - 750 heures d'utilisation d'une instance t2.micro
  - Amazon Linux 2 AMI incluse
  - 30GB de stockage EBS

- **S3** :
  - 5GB de stockage standard
  - 20,000 requêtes GET
  - 2,000 requêtes PUT, COPY, POST, LIST

### Limitations du Free Tier
1. **Instance EC2** :
   - Uniquement t2.micro (1 vCPU, 1GB RAM)
   - Une seule instance à la fois
   - Disponible dans toutes les régions AWS

2. **Bucket S3** :
   - Limité à 5GB de stockage
   - Pas de transfert de données sortant gratuit
   - Pas de requêtes de liste illimitées

### Coûts Potentiels
- Les dépassements du Free Tier seront facturés
- Les transferts de données entre régions sont facturés
- Les requêtes S3 supplémentaires sont facturées

### Recommandations pour le Free Tier
1. Surveiller régulièrement l'utilisation dans la console AWS
2. Configurer des alertes de facturation
3. Nettoyer les ressources non utilisées
4. Utiliser la région la plus proche pour minimiser les coûts de transfert

## Configuration des Credentials AWS

1. Créez un fichier `~/.aws/credentials` avec vos credentials AWS :
```ini
[default]
aws_access_key_id = votre_access_key
aws_secret_access_key = votre_secret_key
```

2. Ou configurez les variables d'environnement :
```bash
export AWS_ACCESS_KEY_ID="votre_access_key"
export AWS_SECRET_ACCESS_KEY="votre_secret_key"
export AWS_REGION="eu-west-3"
```

## Utilisation

1. Initialiser Terraform :
```bash
terraform init
```

2. Vérifier le plan d'exécution :
```bash
terraform plan
```

3. Appliquer la configuration :
```bash
terraform apply
```

4. Pour détruire l'infrastructure :
```bash
terraform destroy
```

## Variables Configurables

### Variables Globales
- `aws_region` : Région AWS à utiliser (défaut: eu-west-3)
- `environment` : Environnement (dev, prod, etc.)
- `instance_type` : Type d'instance EC2 (défaut: t2.micro)

### Variables du Module EC2
- `ami_id` : ID de l'AMI à utiliser
- `instance_name` : Nom de l'instance EC2
- `tags` : Tags à appliquer aux ressources

### Variables du Module S3
- `bucket_name` : Nom de base du bucket S3
- `tags` : Tags à appliquer aux ressources

## Sorties

- `bucket_name` : Nom du bucket S3 créé
- `instance_public_ip` : IP publique de l'instance EC2

## Sécurité

- Le bucket S3 est configuré en privé par défaut
- Les règles de sécurité sont configurées pour :
  - SSH (port 22)
  - Tomcat (port 8080)
  - Tout le trafic sortant est autorisé

## Maintenance

### Mise à jour de Java/Tomcat
Le script d'initialisation de l'instance EC2 installe automatiquement :
- Java 11
- Tomcat 9.0.102
- Les services sont configurés pour démarrer automatiquement

### Gestion des Tags
Les ressources sont taguées avec :
- Environment (dev, prod, etc.)
- Project (Java-Tomcat-Server)
- Name (nom spécifique à chaque ressource)

## Documentation Technique

### Architecture Technique

#### Instance EC2
- **Système d'exploitation** : Amazon Linux 2 (AMI ID: ami-06903a0d7dc8effb5)
  - Distribution optimisée pour AWS
  - Support natif des services AWS
  - Mises à jour de sécurité automatiques

- **Configuration Java** :
  - Version : Java 11 (Amazon Corretto)
  - Distribution : Amazon Corretto (optimisée pour AWS)
  - Installation : Via yum package manager
  - Configuration : Variables d'environnement JAVA_HOME configurées automatiquement

- **Serveur Tomcat** :
  - Version : Tomcat 
  - Port : 8080
  - Installation : Via yum package manager
  - Service : Configuré pour démarrer automatiquement
  - Configuration : Paramètres par défaut sécurisés

- **Sécurité** :
  - Groupe de sécurité dédié
  - Règles d'entrée :
    - SSH (port 22) : Accès pour l'administration
    - Tomcat (port 8080) : Accès pour l'application
  - Règles de sortie : Tout le trafic autorisé
  - Tags de sécurité pour la traçabilité

#### Bucket S3
- **Configuration** :
  - Nom unique généré automatiquement
  - Format : `{bucket_name}-{random_hex}`
  - Région : Même que l'instance EC2

- **Sécurité** :
  - Accès public complètement bloqué
  - Configuration via `aws_s3_bucket_public_access_block`
  - Pas de politiques publiques
  - ACLs publics désactivés

- **Organisation** :
  - Tags pour la gestion des coûts
  - Métadonnées pour la traçabilité
  - Nommage standardisé

### Scripts d'Initialisation

#### Script EC2 (user_data)
```bash
#!/bin/bash
# Mise à jour du système
yum update -y

# Installation de Java 11
yum install java-11-amazon-corretto -y

# Installation de Tomcat
yum install tomcat -y

# Démarrage et activation de Tomcat
systemctl start tomcat
systemctl enable tomcat
```