import os

# DEBUG = True

CONTENT_ORIGIN = "http://loclahost:8000"

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'pulp',
        'HOST': os.environ.get('PULP_DB_HOST', 'localhost'),
        'PORT': os.environ.get('PULP_DB_PORT', ''),
        'USER': 'pulp',
        'PASSWORD': 'secret',
    }
}

AUTH_USER_MODEL = 'galaxy.user'
