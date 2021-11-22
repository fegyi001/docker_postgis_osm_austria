#!/bin/sh

set -e

osm2pgsql -s -H postgis -P 5432 -U postgres -W -d $DB_NAME /opt/downloads/austria-latest.osm -E 3416 -S /usr/share/osm2pgsql/default.style
