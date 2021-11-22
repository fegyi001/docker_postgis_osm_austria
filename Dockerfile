ARG POSTGRES_VERSION

FROM postgres:${POSTGRES_VERSION}

ARG TIMEZONE 
ARG POSTGIS_VERSION

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  gdal-bin wget osm2pgsql bzip2 libproj-dev git \
  postgresql-$PG_MAJOR-postgis-${POSTGIS_VERSION} \
  postgresql-$PG_MAJOR-postgis-${POSTGIS_VERSION}-scripts \
  postgresql-server-dev-$PG_MAJOR \
  postgresql-$PG_MAJOR-ogr-fdw \
  && apt-get purge -y --auto-remove postgresql-server-dev-$PG_MAJOR

# set time zone
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
  && echo ${TIMEZONE} > /etc/timezone

WORKDIR /opt/downloads

RUN wget http://download.geofabrik.de/europe/austria-latest.osm.bz2 \ 
  && bzip2 -d austria-latest.osm.bz2

RUN apt-get -y autoremove wget bzip2 git

# add init script
RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/postgis.sh

# create volume for backups
VOLUME ["/opt/backup"]
VOLUME ["/opt/restore"]

ENV APP /app
WORKDIR $APP

RUN rm -rf /opt/downloads/osmgwc
COPY ./import_osm.sh $APP
RUN chmod +x $APP/*.sh

USER postgres