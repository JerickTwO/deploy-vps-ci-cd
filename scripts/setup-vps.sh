#!/bin/bash

# Script de configuración inicial para VPS
# Ejecutar como root: sudo bash setup-vps.sh

echo "🚀 Configurando VPS para CI/CD..."

# Actualizar sistema
apt update && apt upgrade -y

# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
usermod -aG docker $USER

# Instalar Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Crear directorio para la aplicación
mkdir -p /opt/hello-world
cd /opt/hello-world

# Crear archivo de variables de entorno
cat > .env << EOF
DOCKERHUB_USERNAME=tu_usuario_dockerhub
SPRING_PROFILES_ACTIVE=production
EOF

# Configurar firewall
ufw allow ssh
ufw allow 80
ufw allow 443
ufw --force enable

# Crear usuario para despliegue (opcional)
useradd -m -s /bin/bash deploy
usermod -aG docker deploy
mkdir -p /home/deploy/.ssh

echo "📋 Configuración completada!"
echo ""
echo "⚠️  PASOS SIGUIENTES:"
echo "1. Configura las variables de entorno en .env"
echo "2. Copia tu clave SSH pública a /home/deploy/.ssh/authorized_keys"
echo "3. Configura los secrets en GitHub:"
echo "   - VPS_HOST: IP de tu VPS"
echo "   - VPS_USERNAME: deploy (o el usuario que uses)"
echo "   - VPS_SSH_KEY: tu clave SSH privada"
echo "   - DOCKERHUB_USERNAME: tu usuario de Docker Hub"
echo "   - DOCKERHUB_TOKEN: tu token de Docker Hub"
echo ""
echo "4. Ejecuta el primer despliegue manualmente:"
echo "   cd /opt/hello-world"
echo "   docker-compose up -d"
