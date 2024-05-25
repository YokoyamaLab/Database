FROM mcr.microsoft.com/devcontainers/base:bullseye

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends postgresql-client

RUN echo "alias psql='/usr/bin/psql -h db -p 5432 -U postgres -d postgres'" >> /etc/bash.bashrc
