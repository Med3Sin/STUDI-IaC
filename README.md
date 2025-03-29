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
    ├── s3/               # Module pour le bucket S3
    │   ├── main.tf       # Configuration du bucket S3
    │   ├── variables.tf  # Variables spécifiques au module S3
    │   └── outputs.tf    # Sorties du module S3
    └── rds/              # Module pour la base de données RDS
        ├── main.tf       # Configuration de l'instance RDS
        ├── variables.tf  # Variables spécifiques au module RDS
        └── outputs.tf    # Sorties du module RDS
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

### Base de données RDS
- Instance MySQL éligible au niveau gratuit (par défaut `db.t3.micro`)
- Stockage initial de 20 Go (par défaut)
- Configuration via un module dédié (`modules/rds`)
- Gestion des identifiants via `terraform.tfvars` (voir section Configuration)

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

## Configuration des Variables Sensibles (Base de Données)

Pour configurer les identifiants de la base de données RDS (nom de la base, utilisateur, mot de passe), vous devez créer un fichier nommé `terraform.tfvars` à la racine du projet. Ce fichier **ne doit pas** être ajouté à votre dépôt Git.

1.  **Créez le fichier `terraform.tfvars`** à la racine du projet.
2.  **Ajoutez les variables suivantes** dans ce fichier en remplaçant les valeurs d'exemple par vos propres informations sécurisées :

    ```hcl
    # terraform.tfvars - NE PAS COMMITTER DANS GIT

    db_name     = "votre_nom_de_base"
    db_username = "votre_nom_utilisateur"
    db_password = "votre_mot_de_passe_securise"
    ```

3.  **Assurez-vous que `*.tfvars` est bien présent dans votre fichier `.gitignore`** pour éviter de committer accidentellement ce fichier. Le fichier `.gitignore` fourni avec ce projet inclut déjà cette règle.

Terraform chargera automatiquement les valeurs de ce fichier lors de l'exécution des commandes `plan` et `apply`.

## Utilisation

1. Initialiser Terraform (installe les providers et les modules) :
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
- `db_name` : Nom de la base de données RDS (défini dans `terraform.tfvars`)
- `db_username` : Nom d'utilisateur de la base de données RDS (défini dans `terraform.tfvars`)
- `db_password` : Mot de passe de la base de données RDS (défini dans `terraform.tfvars`, sensible)

### Variables du Module EC2
- `instance_name` : Nom de l'instance EC2
- `instance_type` : Type d'instance EC2 (défaut: t2.micro)
- `tags` : Tags à appliquer aux ressources

### Variables du Module S3
- `bucket_name` : Nom de base du bucket S3
- `tags` : Tags à appliquer aux ressources

### Variables du Module RDS
- `db_identifier` : Identifiant unique de l'instance RDS
- `allocated_storage` : Espace de stockage en Go (défaut: 20)
- `engine` : Moteur de base de données (défaut: mysql)
- `engine_version` : Version du moteur (défaut: 8.0)
- `instance_class` : Classe d'instance (défaut: db.t3.micro)
- `db_name` : Nom de la base de données (hérité de la variable racine)
- `db_username` : Nom d'utilisateur (hérité de la variable racine)
- `db_password` : Mot de passe (hérité de la variable racine, sensible)
- `parameter_group_name` : Groupe de paramètres (défaut: null)
- `publicly_accessible` : Accessibilité publique (défaut: false)
- `tags` : Tags à appliquer aux ressources

## Sorties

- `bucket_name` : Nom du bucket S3 créé
- `instance_public_ip` : IP publique de l'instance EC2
- `db_instance_address` : Adresse (endpoint) de l'instance RDS
- `db_instance_name` : Nom de la base de données (DB Name) de l'instance RDS

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
- **Système d'exploitation** : Amazon Linux 2 (AMI trouvée dynamiquement via `data "aws_ami"`)
  - Distribution optimisée pour AWS
  - Support natif des services AWS
  - Mises à jour de sécurité via `yum update` dans le script d'initialisation

- **Configuration Java** :
  - Version : Java 11 (OpenJDK)
  - Installation : Via `amazon-linux-extras install java-openjdk11 -y`
  - Configuration : Variable d'environnement `JAVA_HOME` définie dans le service systemd de Tomcat

- **Serveur Tomcat** :
  - Version : Tomcat 9.0.102 (téléchargée depuis dlcdn.apache.org)
  - Port : 8080
  - Installation : Manuelle dans `/opt/tomcat` via script `user_data`
  - Service : Fichier de service systemd (`/etc/systemd/system/tomcat.service`) créé et activé via `user_data` pour démarrage automatique
  - Configuration : Paramètres par défaut, exécuté via `startup.sh`/`shutdown.sh`

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
Le script suivant est exécuté au premier démarrage de l'instance pour installer et configurer Java et Tomcat :
```bash
#!/bin/bash
# Mise à jour du système pour avoir les dernières versions des paquets
sudo yum update -y

# Installer Java
amazon-linux-extras install java-openjdk11 -y

# Installer Tomcat
mkdir -p /opt/tomcat
cd /opt/tomcat
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.102/bin/apache-tomcat-9.0.102.tar.gz
tar -xzvf apache-tomcat-9.0.102.tar.gz
mv apache-tomcat-9.0.102/* /opt/tomcat/
rm apache-tomcat-9.0.102.tar.gz

# Configurer les permissions
chmod +x /opt/tomcat/bin/*.sh

# Démarrer Tomcat (initialement, avant la création du service)
# /opt/tomcat/bin/startup.sh # Commenté car le service le fera

# Créer un service systemd pour Tomcat
cat > /etc/systemd/system/tomcat.service << 'EOL'
[Unit]
Description=Apache Tomcat
After=network.target

[Service]
Type=forking
Environment=JAVA_HOME=/usr/lib/jvm/java-11-openjdk
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
EOL

# Activer et démarrer le service
systemctl daemon-reload
systemctl enable tomcat
systemctl start tomcat
```
