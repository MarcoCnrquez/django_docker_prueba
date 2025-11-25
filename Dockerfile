# Dockerfile

# 1. IMAGEN BASE: Elegimos una imagen oficial de Python ligera.
FROM python:3.11-slim

# 2. VARIABLES DE ENTORNO: Configuración estándar para optimizar Python dentro de Docker.
ENV PYTHONUNBUFFERED 1
# Configura dónde buscar el archivo settings.py (REEMPLAZA 'pruebaproyecto')
ENV DJANGO_SETTINGS_MODULE pruebaproyecto.settings

# 3. DIRECTORIO DE TRABAJO: Donde vivirá el código dentro del contenedor.
WORKDIR /usr/src/app

# --- PASO AGREGADO: INSTALAR DEPENDENCIAS DE COMPILACIÓN DE LINUX ---
# 4. INSTALAR HERRAMIENTAS DE LINUX: Necesarias para compilar psycopg.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*
# ------------------------------------------------------------------

# 5. DEPENDENCIAS DE PYTHON: Copiar e instalar el requirements.txt.
# Esto crea una "capa" separada, mejorando la caché de Docker.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 6. CÓDIGO: Copiar todo el código fuente del proyecto al directorio de trabajo.
COPY . .

# 7. PUERTO: Informar a Docker que la aplicación usará este puerto.
EXPOSE 8000

# 8. COMANDO DE INICIO: Ejecutar Gunicorn, sirviendo la aplicación WSGI.
# (REEMPLAZA 'pruebaproyecto' con el nombre de tu carpeta principal)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "pruebaproyecto.wsgi:application"]