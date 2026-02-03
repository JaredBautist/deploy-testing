#!/bin/bash
set -e

echo "=========================================="
echo "Starting Unified Container"
echo "=========================================="

# URLs internas entre servicios
export RESERVATIONS_BASE_URL="http://127.0.0.1:8003/api"
export SPACES_BASE_URL="http://127.0.0.1:8002/api"

echo "Step 1: Waiting for database..."
cd /app/accounts
python wait_for_db.py

echo "Step 2: Running migrations..."
cd /app/accounts && python manage.py migrate --noinput
cd /app/spaces && python manage.py migrate --noinput
cd /app/reservations && python manage.py migrate --noinput

echo "Step 3: Creating admin user..."
cd /app/accounts
python create_admin.py

echo "Step 4: Starting services..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
