#!/bin/bash
set -e

echo "=========================================="
echo "Starting Unified Container"
echo "=========================================="

# Railway asigna el puerto en $PORT, default 80
export PORT=${PORT:-80}
echo "Using PORT: $PORT"

export RESERVATIONS_BASE_URL="http://127.0.0.1:8003/api"
export SPACES_BASE_URL="http://127.0.0.1:8002/api"

echo "Step 1: Configuring nginx with PORT=$PORT..."
envsubst '${PORT}' < /etc/nginx/conf.d/default.conf > /tmp/nginx.conf
mv /tmp/nginx.conf /etc/nginx/conf.d/default.conf

echo "Step 2: Waiting for database..."
cd /app/accounts
python wait_for_db.py

echo "Step 3: Running migrations..."
cd /app/accounts && python manage.py migrate --noinput
cd /app/spaces && python manage.py migrate --noinput
cd /app/reservations && python manage.py migrate --noinput

echo "Step 4: Collecting static files..."
cd /app/accounts && python manage.py collectstatic --noinput || true

echo "Step 5: Creating admin user..."
cd /app/accounts
python create_admin.py

echo "Step 6: Verifying admin user..."
cd /app/accounts
python -c "
import os
import django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'accounts_service.settings')
django.setup()
from django.contrib.auth import get_user_model
User = get_user_model()
users = User.objects.all()
print(f'Total users in database: {users.count()}')
for u in users:
    print(f'  - {u.email} (active={u.is_active}, role={u.role})')
"

echo "Step 7: Starting services..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
