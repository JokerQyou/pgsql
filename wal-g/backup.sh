#!/bin/bash

# A simple script to push a backup of your database. 

if [ -z ${PGDATA+x} ]; then
  export PGDATA=/var/lib/postgresql/data/pgsql
fi

wal-g backup-push "$PGDATA"
