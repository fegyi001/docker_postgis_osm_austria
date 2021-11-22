#!/bin/bash

set -e

# dump databases
for DATABASE in `psql -At -U postgres -c "select datname from pg_database where datname = '$DB_NAME' and not datistemplate order by datname;" postgres`
do
  echo "Plain backup of $DATABASE"
  pg_dump -U postgres --schema-only -Fc "$DATABASE" > /opt/backup/"$DATABASE"_nodata.$(date -d "today" +"%Y-%m-%d-%H-%M").dump
  pg_dump -U postgres -Fc "$DATABASE" > /opt/backup/"$DATABASE".$(date -d "today" +"%Y-%m-%d-%H-%M").dump
done

# delete files older than 5 days
find /opt/backup -mtime +5 -type f -delete
