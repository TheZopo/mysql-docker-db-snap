FROM mariadb:latest

LABEL maintainer="Bastien Marsaud <bastien@mouseover.fr>"

ARG dump_path
COPY ${dump_path} /docker-entrypoint-initdb.d/