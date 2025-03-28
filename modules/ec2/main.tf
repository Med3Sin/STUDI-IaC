# Module EC2 - Configuration de l'instance EC2 et de ses ressources associées

# Création de l'instance EC2 principale
resource "aws_instance" "instance" {
  # Spécification de l'AMI (Amazon Machine Image) à utiliser
  ami           = var.ami_id
  # Type d'instance EC2 (t2.micro, t2.small, etc.)
  instance_type = var.instance_type

  # Script d'initialisation qui s'exécute au premier démarrage de l'instance
  user_data = <<-EOF
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
              
              # Démarrer Tomcat
              /opt/tomcat/bin/startup.sh
              
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
              EOF

  # Configuration des tags pour l'instance
  # merge() combine les tags par défaut avec les tags spécifiques fournis
  tags = merge(
    var.tags,
    {
      Name = var.instance_name
    }
  )

  # Association directe du groupe de sécurité à l'instance
  vpc_security_group_ids = [aws_security_group.security_group.id]
}

# Création du groupe de sécurité pour l'instance EC2
resource "aws_security_group" "security_group" {
  # Nom unique pour le groupe de sécurité basé sur le nom de l'instance
  name = "${var.instance_name}-sg"

  # Règle pour permettre l'accès SSH (port 22) depuis n'importe quelle IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Règle pour permettre l'accès à Tomcat (port 8080) depuis n'importe quelle IP
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Règle pour permettre tout le trafic sortant
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Application des tags au groupe de sécurité
  tags = var.tags
} 