#!/bin/bash

# Recovery script: 
# * Calls wal-g to recover the latest database
# * Configures postgres to enter recovery mode by:
# * 1. Setting signal
# * 2. Appending wal-g recovery commands onto postgresql.conf
# * 3. Configuring postgres to only allow connections from localhost, preventing concurrent updates
# * 4. Disabling archive mode so as not to corrupt S3 backups
# * Starts postgres
#
# When recovery is done, hit ^C and start database using `/docker-entrypoint.sh postgres` and you should be able to connect to the database and verify backups are OK.
# If you get an error message, DON'T PANIC! Just read the message and do what it tells you to do. 

if [ $(id -u) == "0" ] ; then
  echo "this command must be run as the postgres user."
  exit 1
fi

set -e

if [ -z ${PGDATA+x} ]; then
  export PGDATA=/var/lib/postgresql/data/pgsql
fi

# fetch most recent full backup
wal-g backup-fetch $PGDATA LATEST

# enable recovery mode, disable remote connections and archive mode
touch $PGDATA/recovery.signal
cp $PGDATA/postgresql.conf $PGDATA/postgresql.conf.orig
cat /wal-g/recovery.conf >> $PGDATA/postgresql.conf
mv $PGDATA/pg_hba.conf $PGDATA/pg_hba.conf.orig
cp /wal-g/pg_hba.conf $PGDATA/pg_hba.conf
sed -i -e 's/^archive_mode = on/archive_mode = off/' $PGDATA/postgresql.conf

PG_VERSION=$(ls /usr/lib/postgresql/)

/usr/lib/postgresql/$PG_VERSION/bin/pg_ctl start -D $PGDATA
