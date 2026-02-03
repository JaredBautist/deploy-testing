# Despliegue Unificado en Railway

Este documento describe cómo desplegar el sistema de reservas como **un solo servicio** en Railway.

## Arquitectura

```
┌────────────────────────────────────────────────────────┐
│              Railway Project (2 servicios)             │
├────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────┐   │
│  │         Contenedor Unificado (Puerto 80)        │   │
│  │  ┌──────────────────────────────────────────┐   │   │
│  │  │  Nginx (routing + frontend estático)      │   │   │
│  │  └──────────────────────────────────────────┘   │   │
│  │         │           │           │               │   │
│  │         ▼           ▼           ▼               │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────────┐    │   │
│  │  │ Accounts │ │  Spaces  │ │ Reservations │    │   │
│  │  │  :8001   │ │  :8002   │ │    :8003     │    │   │
│  │  └──────────┘ └──────────┘ └──────────────┘    │   │
│  └─────────────────────────────────────────────────┘   │
│                                                        │
│  ┌─────────────┐                                       │
│  │    MySQL    │                                       │
│  │  (Database) │                                       │
│  └─────────────┘                                       │
└────────────────────────────────────────────────────────┘
```

## Paso 1: Crear el Proyecto en Railway

1. Ve a [Railway](https://railway.app) e inicia sesión
2. Crea un nuevo proyecto: **New Project** → **Empty Project**

## Paso 2: Agregar Base de Datos MySQL

1. Click **+ New** → **Database** → **MySQL**
2. Railway creará automáticamente una instancia MySQL
3. Anota las credenciales o usa la variable `DATABASE_URL`

## Paso 3: Desplegar el Servicio Unificado

1. Click **+ New** → **GitHub Repo**
2. Selecciona tu repositorio
3. Railway detectará automáticamente el `Dockerfile.unified` configurado en `railway.toml`

## Paso 4: Configurar Variables de Entorno

En la pestaña **Variables** del servicio, configura:

```bash
# Opción A: Usar DATABASE_URL (recomendado)
DATABASE_URL=${{MySQL.DATABASE_URL}}

# Opción B: Variables individuales
DB_HOST=${{MySQL.MYSQLHOST}}
DB_PORT=${{MySQL.MYSQLPORT}}
DB_NAME=${{MySQL.MYSQLDATABASE}}
DB_USER=${{MySQL.MYSQLUSER}}
DB_PASSWORD=${{MySQL.MYSQLPASSWORD}}

# Django
DJANGO_SECRET_KEY=genera-una-clave-secreta-segura-aqui
DJANGO_DEBUG=0
ALLOWED_HOSTS=*.railway.app,*.up.railway.app

# JWT (muy importante)
JWT_SECRET=tu-jwt-secret-super-seguro

# CORS
CORS_ALLOWED_ORIGINS=https://tu-app.up.railway.app
CORS_ALLOW_ALL_ORIGINS=true
CSRF_TRUSTED_ORIGINS=https://*.railway.app,https://*.up.railway.app

# Timezone
TIME_ZONE=America/Bogota

# Admin inicial
ADMIN_EMAIL=admin@tudominio.com
ADMIN_PASSWORD=password_seguro
ADMIN_FIRST_NAME=Admin
ADMIN_LAST_NAME=Sistema

# Reservations
RESERVATION_MIN_DURATION_MINUTES=30
RESERVATION_MAX_DURATION_HOURS=4
```

## Paso 5: Generar Dominio

1. Ve a **Settings** → **Networking**
2. Click **Generate Domain**
3. Tu app estará disponible en `https://tu-app.up.railway.app`

## Verificación

### Verificar el Frontend
Abre `https://tu-app.up.railway.app` en el navegador.

### Verificar las APIs
```bash
# Login
curl https://tu-app.up.railway.app/api/auth/login/ \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@tudominio.com","password":"tu-password"}'

# Spaces (con token)
curl https://tu-app.up.railway.app/api/spaces/ \
  -H "Authorization: Bearer <token>"

# Reservations (con token)
curl https://tu-app.up.railway.app/api/reservations/ \
  -H "Authorization: Bearer <token>"
```

## Ventajas del Despliegue Unificado

- **Menor costo**: Solo 2 servicios (app + MySQL) en lugar de 5+
- **Simplicidad**: Un solo despliegue, una sola URL
- **Sin latencia de red**: Los servicios se comunican internamente via localhost
- **Fácil mantenimiento**: Todo en un solo contenedor

## Estructura del Contenedor

```
/app
├── accounts/          # Accounts service (puerto 8001)
├── spaces/            # Spaces service (puerto 8002)
├── reservations/      # Reservations service (puerto 8003)
└── start.sh           # Script de inicio

/usr/share/nginx/html  # Frontend estático

Supervisord gestiona:
├── nginx              # Puerto 80 (externo)
├── accounts           # gunicorn :8001
├── spaces             # gunicorn :8002
└── reservations       # gunicorn :8003
```

## Logs y Debugging

En Railway, ve a la pestaña **Deployments** → **View Logs** para ver:
- Logs de inicio (migraciones, creación de admin)
- Logs de cada servicio (accounts, spaces, reservations)
- Logs de nginx

## Costos Estimados

- **App Unificada**: ~$5-10/mes (según uso)
- **MySQL**: ~$5/mes
- **Total**: ~$10-15/mes

Comparado con la arquitectura de microservicios (~$25-40/mes), esto representa un ahorro significativo.
