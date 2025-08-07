#!/bin/bash

# Script de despliegue manual
# Usar en caso de que el CI/CD falle

set -e

echo "🚀 Iniciando despliegue manual..."

# Variables
IMAGE_NAME="hello-world-app"
CONTAINER_NAME="hello-world-container"

# Verificar que Docker esté corriendo
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker no está corriendo"
    exit 1
fi

# Construir imagen localmente (si no usas Docker Hub)
echo "🔨 Construyendo imagen Docker..."
docker build -t $IMAGE_NAME:latest .

# Parar contenedor anterior si existe
echo "🛑 Parando contenedor anterior..."
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

# Ejecutar nuevo contenedor
echo "▶️  Iniciando nuevo contenedor..."
docker run -d \
  --name $CONTAINER_NAME \
  --restart unless-stopped \
  -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=production \
  $IMAGE_NAME:latest

# Verificar que el contenedor esté corriendo
sleep 5
if docker ps | grep -q $CONTAINER_NAME; then
    echo "✅ Contenedor iniciado correctamente"
    
    # Verificar que la aplicación responda
    echo "🔍 Verificando aplicación..."
    sleep 10
    
    if curl -f http://localhost:8080/ > /dev/null 2>&1; then
        echo "✅ Aplicación desplegada exitosamente!"
        echo "🌐 Accede a: http://localhost:8080"
    else
        echo "❌ La aplicación no responde"
        docker logs $CONTAINER_NAME
        exit 1
    fi
else
    echo "❌ Error al iniciar el contenedor"
    docker logs $CONTAINER_NAME
    exit 1
fi

# Limpiar imágenes antigas
echo "🧹 Limpiando imágenes antiguas..."
docker image prune -f
