#!/bin/bash
set -e

echo "=========================================="
echo "Starting Unified Container"
echo "=========================================="

# Configurar URLs internas para comunicación entre servicios
export RESERVATIONS_BASE_URL="http://127.0.0.1:8003/api"
export SPACES_BASE_URL="http://127.0.0.1:8002/api"

# Parsear DATABASE_URL si está definido para extraer componentes
# Formato: mysql://user:password@host:port/database
if [ -n "$DATABASE_URL" ]; then
    echo "Parsing DATABASE_URL..."
    # Extraer componentes de la URL
    # Soporta formato: mysql://user:password@host:port/database
    proto="$(echo $DATABASE_URL | grep :// | sed -e's,^\(.*://\).*,\1,g')"
    url="${DATABASE_URL/$proto/}"
    userpass="$(echo $url | grep @ | cut -d@ -f1)"
    hostport="$(echo $url | sed -e s,$userpass@,,g | cut -d/ -f1)"

    export DB_USER="$(echo $userpass | cut -d: -f1)"
    export DB_PASSWORD="$(echo $userpass | cut -d: -f2)"
    export DB_HOST="$(echo $hostport | cut -d: -f1)"
    export DB_PORT="$(echo $hostport | cut -d: -f2)"
    export DB_NAME="$(echo $url | grep / | cut -d/ -f2-)"

    echo "Database: $DB_HOST:$DB_PORT/$DB_NAME"
fi

# Función para esperar la base de datos
wait_for_db() {
    local service_name=$1
    local service_dir=$2

    echo "[$service_name] Waiting for database..."
    cd /app/$service_dir
    python wait_for_db.py
    echo "[$service_name] Database ready!"
}

# Función para ejecutar migraciones
run_migrations() {
    local service_name=$1
    local service_dir=$2
    local settings_module=$3

    echo "[$service_name] Running migrations..."
    cd /app/$service_dir
    DJANGO_SETTINGS_MODULE=$settings_module python manage.py migrate --noinput
    echo "[$service_name] Migrations complete!"
}

# Esperar a que la base de datos esté lista (solo necesitamos verificar una vez si es la misma DB)
echo ""
echo "Step 1: Waiting for database..."
wait_for_db "accounts" "accounts"

# Ejecutar migraciones para cada servicio
echo ""
echo "Step 2: Running migrations..."
run_migrations "accounts" "accounts" "accounts_service.settings"
run_migrations "spaces" "spaces" "spaces_service.settings"
run_migrations "reservations" "reservations" "reservations_service.settings"

# Crear usuario administrador
echo ""
echo "Step 3: Creating admin user..."
cd /app/accounts
DJANGO_SETTINGS_MODULE=accounts_service.settings python create_admin.py

# Iniciar Supervisor (que a su vez inicia nginx, accounts, spaces, reservations)
echo ""
echo "Step 4: Starting services with Supervisor..."
echo "=========================================="
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
