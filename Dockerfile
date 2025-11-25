# Dockerfile

FROM python:3.11-slim

ENV PYTHONUNBUFFERED 1
ENV DJANGO_SETTINGS_MODULE django_docker_prueba.settings

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

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "django_docker_prueba.wsgi:application"]
