FROM centos:7

ENV LANG=en_US.UTF-8 \
    PYTHONUNBUFFERED=1 \
    ENABLED_COLLECTIONS="rh-python36 rh-postgresql12" \
    PULP_SETTINGS=/etc/pulp/settings.py \
    DJANGO_SETTINGS_MODULE=pulpcore.app.settings

RUN yum -y install centos-release-scl-rh \
    && yum -y install \
        gcc \
        git \
        rh-python36 \
        rh-postgresql12-postgresql-libs \
        rh-postgresql12-postgresql-devel \
    && yum -y clean all

RUN mkdir -p /var/run/pulp \
    /var/lib/pulp/static \
    /var/lib/pulp/tmp

COPY src/pulp_galaxy /app
COPY dev/pulp_galaxy/settings.py /etc/pulp/settings.py
COPY dev/pulp_galaxy/entrypoint.sh /entrypoint

RUN source scl_source enable ${ENABLED_COLLECTIONS} \
    && pip install --no-cache-dir -U pip \
    && pip install --no-cache-dir -e /app \
    && PULP_CONTENT_ORIGIN=x django-admin collectstatic

RUN chmod 755 /entrypoint

ENTRYPOINT [ "/entrypoint" ]
