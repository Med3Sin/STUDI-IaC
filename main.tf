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

# Affichage des informations importantes
output "bucket_name" {
  value = module.s3.bucket_id
}

output "instance_public_ip" {
  value = module.ec2.public_ip
}
