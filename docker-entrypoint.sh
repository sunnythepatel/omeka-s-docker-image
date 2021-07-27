#!/bin/sh
set -e

# if [ "$1" = 'postgres' ]; then
#     chown -R postgres "$PGDATA"

#     if [ -z "$(ls -A "$PGDATA")" ]; then
#         gosu postgres initdb
#     fi

#     exec gosu postgres "$@"
# fi
chown -R www-data:www-data /var/www/html/files 
python3 /var/www/html/database.py
exec "$@"