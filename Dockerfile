FROM python:3.11-slim

# Asegura que la salida de Python se envíe directamente al terminal
ENV PYTHONUNBUFFERED 1

# Define dónde se encuentran los settings de Django
ENV DJANGO_SETTINGS_MODULE pruebaproyecto.settings 

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /usr/src/app

# Instala dependencias del sistema necesarias para PostgreSQL (psycopg2) y compilación
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copia e instala las dependencias de Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia todo el código del proyecto al contenedor
COPY . .

# Comando de arranque de Gunicorn
# La variable $PORT se expande correctamente en formato shell.
CMD gunicorn pruebaproyecto.wsgi:application --bind 0.0.0.0:$PORT