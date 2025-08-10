# Hello World Spring Boot - CI/CD con Docker

Este proyecto implementa una aplicación Spring Boot con un pipeline completo de CI/CD usando GitHub Actions, Docker y despliegue en VPS.

## 🚀 Características

- **Spring Boot 3.5.4** con Java 21
- **Docker** multi-stage build optimizado
- **CI/CD** con GitHub Actions
- **Nginx** como reverse proxy
- **Health checks** y monitoreo
- **Despliegue automático** en VPS

## 📋 Endpoints Disponibles

- `GET /` - Hola mundo principal
- `GET /hola` - Saludo de bienvenida
- `GET /saludo` - Saludo desde el controlador
- `GET /actuator/health` - Health check

## 🛠️ Configuración Inicial

### 1. Preparar el VPS

Ejecuta el script de configuración en tu VPS:

```bash
# Copiar script al VPS
scp scripts/setup-vps.sh usuario@tu-vps:/tmp/
ssh usuario@tu-vps

# Ejecutar como root
sudo bash /tmp/setup-vps.sh
```

### 2. Configurar Docker Hub

1. Crea una cuenta en [Docker Hub](https://hub.docker.com/)
2. Genera un Access Token en Settings > Security

### 3. Configurar GitHub Secrets

Ve a tu repositorio > Settings > Secrets and variables > Actions y agrega:
 
```
VPS_HOST=1.2.3.4                    # IP de tu VPS
VPS_USERNAME=deploy                  # Usuario para SSH
VPS_SSH_KEY=-----BEGIN PRIVATE...   # Tu clave SSH privada
DOCKERHUB_USERNAME=tu_usuario        # Tu usuario de Docker Hub
DOCKERHUB_TOKEN=dckr_pat_...         # Tu token de Docker Hub
```

### 4. Configurar el VPS

```bash
# Conectarse al VPS
ssh deploy@tu-vps

# Ir al directorio de la aplicación
cd /opt/hello-world

# Editar variables de entorno
nano .env
```

Contenido del `.env`:
```bash
DOCKERHUB_USERNAME=tu_usuario_dockerhub
SPRING_PROFILES_ACTIVE=production
```

### 5. Copiar archivos de configuración

```bash
# Copiar docker-compose.yml y nginx config al VPS
scp docker-compose.yml deploy@tu-vps:/opt/hello-world/
scp -r nginx/ deploy@tu-vps:/opt/hello-world/
```

## 🔄 Pipeline CI/CD

El pipeline se ejecuta automáticamente cuando:
- Hay push a `main` o `develop`
- Se crea un Pull Request a `main`

### Fases del Pipeline:

1. **Test**: Ejecuta tests unitarios
2. **Build**: Construye y publica imagen Docker
3. **Deploy**: Despliega en VPS usando SSH

## 🐳 Comandos Docker Locales

```bash
# Construir imagen
docker build -t hello-world-app .

# Ejecutar localmente
docker run -p 8080:8080 hello-world-app

# Con docker-compose
docker-compose up -d

# Ver logs
docker-compose logs -f

# Parar servicios
docker-compose down
```

## 🔧 Despliegue Manual

Si necesitas desplegar manualmente:

```bash
# En el VPS
cd /opt/hello-world
bash scripts/deploy.sh
```

## 📊 Monitoreo y Logs

```bash
# Ver estado de contenedores
docker ps

# Ver logs de la aplicación
docker logs hello-world-container -f

# Ver métricas
curl http://localhost:8080/actuator/health

# Ver logs de Nginx
docker logs nginx-proxy -f
```

## 🔒 Configuración de SSL (Opcional)

Para configurar HTTPS:

1. Obtén certificados SSL (Let's Encrypt recomendado)
2. Coloca los certificados en `nginx/ssl/`
3. Descomenta la configuración SSL en `nginx/nginx.conf`
4. Actualiza el `docker-compose.yml` para montar los certificados

```bash
# Obtener certificados con Certbot
sudo apt install certbot
sudo certbot certonly --standalone -d tu-dominio.com
```

## 🚨 Troubleshooting

### La aplicación no inicia
```bash
# Ver logs detallados
docker logs hello-world-container

# Verificar configuración
docker inspect hello-world-container
```

### Problemas de conexión
```bash
# Verificar puertos
netstat -tlnp | grep 8080

# Verificar firewall
sudo ufw status
```

### Pipeline falla
- Verifica que todos los secrets estén configurados
- Revisa los logs en GitHub Actions
- Verifica conectividad SSH al VPS

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crea un Pull Request

## 📝 Licencia

Este proyecto está bajo la Licencia MIT.
