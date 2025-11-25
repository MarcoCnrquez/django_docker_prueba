FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=pruebaproyecto.settings

WORKDIR /usr/src/app

# Dependencias necesarias para PostgreSQL y compilar paquetes
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Instalar requerimientos
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar proyecto
COPY . .

# Comando principal: migraciones + creación de superusuario + gunicorn
CMD sh -c "python manage.py makemigrations --noinput || true && python manage.py migrate --noinput && echo \"from django.contrib.auth import get_user_model; import os; User=get_user_model(); u=os.environ.get('DJANGO_SUPERUSER_USERNAME'); p=os.environ.get('DJANGO_SUPERUSER_PASSWORD'); e=os.environ.get('DJANGO_SUPERUSER_EMAIL'); qs=User.objects.filter(username=u); print('Creando superusuario...' if not qs.exists() else 'Superusuario ya existe'); User.objects.create_superuser(u, e, p) if (u and p and not qs.exists()) else None\" | python manage.py shell && gunicorn pruebaproyecto.wsgi:application --bind 0.0.0.0:${PORT}"
