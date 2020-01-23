FROM centos:7

ENV LANG=en_US.UTF-8

ENV PYTHONUNBUFFERED=1
ENV ENABLED_COLLECTIONS="rh-python36 rh-postgresql12"


RUN yum -y install centos-release-scl-rh \
    && yum -y install \
        gcc \
        git \
        rh-python36 \
        rh-postgresql12-postgresql-libs \
        rh-postgresql12-postgresql-devel \
    && yum -y clean all

COPY src/pulp_galaxy /app

RUN source scl_source enable ${ENABLED_COLLECTIONS} \
    && pip install -e /app

COPY docker/pulp_galaxy/entrypoint.sh /entrypoint
RUN chmod 755 /entrypoint

ENTRYPOINT [ "/entrypoint" ]
