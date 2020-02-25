# Stage: Base image
# ---------------------------------------------------------
FROM centos:8 AS base

# # Install missing en_US.UTF-8 locale
RUN dnf install -y \
        glibc-langpack-en \
        python3 \
    && dnf -y clean all
ENV LANG=en_US.UTF-8

# Stage: galaxy_api image
# ---------------------------------------------------------
FROM base

ENV PYTHONUNBUFFERED=1 \
    PULP_SETTINGS=/etc/pulp/settings.py \
    DJANGO_SETTINGS_MODULE=pulpcore.app.settings

# Install dependencies
RUN dnf -y install \
        gcc \
        python3-devel \
        libpq \
        libpq-devel \
    && dnf -y clean all

COPY src/pulp_galaxy /app
COPY dev/pulp_galaxy/settings.py /etc/pulp/settings.py
COPY dev/pulp_galaxy/entrypoint.sh /entrypoint

RUN pip3 install --no-cache-dir -U pip \
    && pip3 install --no-cache-dir -e /app \
    && PULP_CONTENT_ORIGIN=x django-admin collectstatic

RUN chmod 755 /entrypoint

ENTRYPOINT [ "/entrypoint" ]
