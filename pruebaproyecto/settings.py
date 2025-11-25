import dj_database_url
from pathlib import Path
import os
from django.core.exceptions import ImproperlyConfigured # Importación necesaria para manejar STATIC_ROOT correctamente


# Build paths inside the project like this: BASE_DIR / 'subdir'.
# Se usa 'os.path' para compatibilidad con la configuración STATIC
BASE_DIR = Path(__file__).resolve().parent.parent


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/5.2/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'django-insecure-@%_ii%bja2l^18ydk1_#-=5#7l7iyk(+o974047h$8hu7yd3p3'


# --- CONFIGURACIÓN PARA DOCKER/PRODUCCIÓN (CORREGIDO) ---
# Lee la configuración de DEBUG de una variable de entorno, por defecto True para desarrollo
DEBUG = os.environ.get('DJANGO_DEBUG', 'True') == 'True' 

# Lee los hosts permitidos de una variable de entorno, por defecto '*' para desarrollo local
# Cuando uses Heroku/AWS, esta variable se debe establecer allí.
ALLOWED_HOSTS = os.environ.get('DJANGO_ALLOWED_HOSTS', '*').split(',')
# --------------------------------------------------------


# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
]
#Middleware sirve para gestionar las solicitudes y respuestas HTTP en Django
# Permite agregar funcionalidades como seguridad, manejo de sesiones, etc.
#Se sincronizan con 
MIDDLEWARE = [  
    'django.middleware.security.SecurityMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'pruebaproyecto.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'pruebaproyecto.wsgi.application'


# Database
# https://docs.djangoproject.com/en/5.2/ref/settings/#databases

DATABASES = {
    'default': dj_database_url.config(
        # 1. Busca la variable de entorno DATABASE_URL (usada en la nube).
        # 2. Si no la encuentra (localmente), usa la URL por defecto de Docker Compose.
        default='postgres://postgres:password@db:5432/postgres', 
        conn_max_age=600,
        # ELIMINADO: 'conn_health_check' que causaba TypeError
    )
}


# Password validation
# https://docs.djangoproject.com/en/5.2/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# Internationalization
# https://docs.djangoproject.com/en/5.2/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_TZ = True


# --- CONFIGURACIÓN DE ARCHIVOS ESTÁTICOS (CORREGIDO) ---
# https://docs.djangoproject.com/en/5.2/howto/static-files/

# Directorio donde 'collectstatic' reunirá los archivos para producción dentro del contenedor.
STATIC_ROOT = BASE_DIR / 'staticfiles'

# URL para servir los archivos estáticos
STATIC_URL = '/static/' 
# Configuración de WhiteNoise para servir archivos estáticos en producción
STATICFILES_STORAGE = "whitenoise.storage.CompressedManifestStaticFilesStorage"

# Directorios adicionales que el gestor de archivos estáticos buscará
STATICFILES_DIRS = [
    BASE_DIR / 'static',
]
# -------------------------------------------------------


# Default primary key field type
# https://docs.djangoproject.com/en/5.2/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'