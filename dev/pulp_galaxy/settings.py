import os

# DEBUG = True

CONTENT_ORIGIN = "http://localhost:8000"
CONTENT_PATH_PREFIX = "/api/galaxy/v3/artifacts/collections/"

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('PULP_DB_NAME', ''),
        'HOST': os.environ.get('PULP_DB_HOST', 'localhost'),
        'PORT': os.environ.get('PULP_DB_PORT', ''),
        'USER': os.environ.get('PULP_DB_USER', ''),
        'PASSWORD': os.environ.get('PULP_DB_PASSWORD', ''),
    }
}

AUTH_USER_MODEL = 'galaxy.user'

DEBUG = True
