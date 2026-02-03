# Despliegue en Railway

Este documento describe cómo desplegar el sistema de reservas de espacios en Railway.

## Arquitectura en Railway

El proyecto se despliega como **5 servicios** en Railway:

```
┌─────────────────────────────────────────────────────────────┐
│                        Railway Project                       │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  Frontend   │  │   MySQL     │  │  Accounts Service   │  │
│  │  (React)    │  │  (Database) │  │  (Django)           │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
│                                                              │
│  ┌─────────────────────┐  ┌───────────────────────────────┐ │
│  │  Spaces Service     │  │  Reservations Service         │ │
│  │  (Django)           │  │  (Django)                     │ │
│  └─────────────────────┘  └───────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## Paso 1: Crear el Proyecto en Railway

1. Ve a [Railway](https://railway.app) e inicia sesión
2. Crea un nuevo proyecto: **New Project** → **Empty Project**

## Paso 2: Agregar Base de Datos MySQL

1. En el proyecto, click **+ New** → **Database** → **MySQL**
2. Railway creará automáticamente una instancia MySQL
3. Anota la variable `DATABASE_URL` que se genera (la usarás para los servicios)

## Paso 3: Desplegar el Servicio Accounts

1. Click **+ New** → **GitHub Repo**
2. Selecciona tu repositorio
3. En la configuración del servicio:
   - **Root Directory**: `services/accounts_service`
   - **Build Command**: (dejar vacío, usa nixpacks.toml)
   - **Start Command**: (dejar vacío, usa nixpacks.toml)

4. Configura las **Variables de Entorno**:
   ```
   DATABASE_URL=${{MySQL.DATABASE_URL}}
   DJANGO_SECRET_KEY=<genera-una-clave-secreta-segura>
   DJANGO_DEBUG=0
   ALLOWED_HOSTS=*.railway.app,*.up.railway.app
   JWT_SECRET=<tu-jwt-secret-compartido>
   CORS_ALLOWED_ORIGINS=https://tu-frontend.up.railway.app
   CORS_ALLOW_ALL_ORIGINS=true
   CSRF_TRUSTED_ORIGINS=https://*.railway.app,https://*.up.railway.app
   TIME_ZONE=America/Bogota
   ADMIN_EMAIL=admin@tudominio.com
   ADMIN_PASSWORD=<password-seguro>
   ADMIN_FIRST_NAME=Admin
   ADMIN_LAST_NAME=Sistema
   ```

5. Click **Deploy**

## Paso 4: Desplegar el Servicio Spaces

1. Click **+ New** → **GitHub Repo**
2. Selecciona el mismo repositorio
3. En la configuración:
   - **Root Directory**: `services/spaces_service`

4. Variables de Entorno:
   ```
   DATABASE_URL=${{MySQL.DATABASE_URL}}
   DJANGO_SECRET_KEY=<otra-clave-secreta>
   DJANGO_DEBUG=0
   ALLOWED_HOSTS=*.railway.app,*.up.railway.app
   JWT_SECRET=<el-mismo-jwt-secret>
   CORS_ALLOWED_ORIGINS=https://tu-frontend.up.railway.app
   CORS_ALLOW_ALL_ORIGINS=true
   CSRF_TRUSTED_ORIGINS=https://*.railway.app,https://*.up.railway.app
   TIME_ZONE=America/Bogota
   RESERVATIONS_BASE_URL=https://tu-reservations-service.up.railway.app/api
   ```

## Paso 5: Desplegar el Servicio Reservations

1. Click **+ New** → **GitHub Repo**
2. Selecciona el mismo repositorio
3. En la configuración:
   - **Root Directory**: `services/reservations_service`

4. Variables de Entorno:
   ```
   DATABASE_URL=${{MySQL.DATABASE_URL}}
   DJANGO_SECRET_KEY=<otra-clave-secreta>
   DJANGO_DEBUG=0
   ALLOWED_HOSTS=*.railway.app,*.up.railway.app
   JWT_SECRET=<el-mismo-jwt-secret>
   CORS_ALLOWED_ORIGINS=https://tu-frontend.up.railway.app
   CORS_ALLOW_ALL_ORIGINS=true
   CSRF_TRUSTED_ORIGINS=https://*.railway.app,https://*.up.railway.app
   TIME_ZONE=America/Bogota
   SPACES_BASE_URL=https://tu-spaces-service.up.railway.app/api
   RESERVATION_MIN_DURATION_MINUTES=30
   RESERVATION_MAX_DURATION_HOURS=4
   ```

## Paso 6: Desplegar el Frontend

1. Click **+ New** → **GitHub Repo**
2. Selecciona el mismo repositorio
3. En la configuración:
   - **Root Directory**: `frontend`
   - Usa el Dockerfile existente

4. Variables de Entorno:
   ```
   ACCOUNTS_SERVICE_URL=https://tu-accounts-service.up.railway.app
   SPACES_SERVICE_URL=https://tu-spaces-service.up.railway.app
   RESERVATIONS_SERVICE_URL=https://tu-reservations-service.up.railway.app
   ```

## Paso 7: Configurar Dominios

1. Para cada servicio, ve a **Settings** → **Networking**
2. Click **Generate Domain** para obtener una URL pública
3. Actualiza las variables de entorno con las URLs correctas:
   - `RESERVATIONS_BASE_URL` en spaces debe apuntar a reservations
   - `SPACES_BASE_URL` en reservations debe apuntar a spaces
   - Las URLs en el frontend deben apuntar a cada servicio backend

## Variables de Entorno Importantes

### JWT_SECRET
**IMPORTANTE**: Debe ser el mismo valor en los 3 servicios backend para que la autenticación funcione.

```bash
# Genera una clave segura con:
python -c "import secrets; print(secrets.token_urlsafe(32))"
```

### DJANGO_SECRET_KEY
Cada servicio puede tener su propia clave secreta única.

```bash
# Genera una clave segura con:
python -c "import secrets; print(secrets.token_urlsafe(50))"
```

## Orden de Despliegue Recomendado

1. **MySQL** (base de datos)
2. **Accounts Service** (autenticación - crea el admin)
3. **Reservations Service**
4. **Spaces Service** (depende de reservations para disponibilidad)
5. **Frontend** (una vez que tengas las URLs de los backends)

## Verificación del Despliegue

### 1. Verificar Accounts Service
```bash
curl https://tu-accounts-service.up.railway.app/api/auth/login/ \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@tudominio.com","password":"tu-password"}'
```

### 2. Verificar Spaces Service
```bash
curl https://tu-spaces-service.up.railway.app/api/spaces/ \
  -H "Authorization: Bearer <token-del-paso-anterior>"
```

### 3. Verificar Reservations Service
```bash
curl https://tu-reservations-service.up.railway.app/api/reservations/ \
  -H "Authorization: Bearer <token>"
```

### 4. Verificar Frontend
Abre `https://tu-frontend.up.railway.app` en el navegador.

## Solución de Problemas

### Error de conexión a base de datos
- Verifica que `DATABASE_URL` esté correctamente configurado
- Asegúrate de que el servicio MySQL esté activo

### Error 401 en las APIs
- Verifica que `JWT_SECRET` sea el mismo en todos los servicios
- Verifica que el token no haya expirado

### CORS errors
- Agrega la URL del frontend a `CORS_ALLOWED_ORIGINS` en cada servicio
- Puedes usar `CORS_ALLOW_ALL_ORIGINS=true` temporalmente para debugging

### Error de migración
- Los servicios ejecutan migraciones automáticamente al iniciar
- Revisa los logs en Railway para ver errores específicos

## Costos Estimados en Railway

Railway cobra por uso:
- **Compute**: ~$5-10/mes por servicio (dependiendo del uso)
- **MySQL**: ~$5/mes para starter
- **Total aproximado**: ~$25-40/mes para la configuración completa

## Alternativa: Base de Datos Externa

Si prefieres usar una base de datos externa (como PlanetScale o otro MySQL):

1. Crea la base de datos en el proveedor externo
2. Usa la URL de conexión proporcionada en `DATABASE_URL`
3. Asegúrate de que el firewall permita conexiones desde Railway

## Monitoreo

Railway proporciona:
- **Logs** en tiempo real para cada servicio
- **Métricas** de CPU, memoria y red
- **Alertas** configurables

Accede desde el dashboard del proyecto → selecciona servicio → pestaña **Observability**.
