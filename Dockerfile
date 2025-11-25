FROM python:3.11-slim

ENV PYTHONUNBUFFERED 1
ENV DJANGO_SETTINGS_MODULE pruebaproyecto.settings 

WORKDIR /usr/src/app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["sh", "-c", "python manage.py migrate && python manage.py makemigrations --noinput || true && python manage.py migrate && echo \"from django.contrib.auth import get_user_model; User = get_user_model(); import os; u=os.environ.get('DJANGO_SUPERUSER_USERNAME'); p=os.environ.get('DJANGO_SUPERUSER_PASSWORD'); e=os.environ.get('DJANGO_SUPERUSER_EMAIL'); \nif u and p and not User.objects.filter(username=u).exists(): User.objects.create_superuser(u, e, p)\" | python manage.py shell && gunicorn pruebaproyecto.wsgi:application --bind 0.0.0.0:$PORT"]
