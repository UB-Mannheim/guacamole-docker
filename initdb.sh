#!/bin/sh

. ./.env

DBCONT_NAME=guacamole_db_1

if [ ! -e initdb.sql ]; then
    docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql > initdb.sql
fi

docker exec -i $DBCONT_NAME mysql <<EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT SELECT,INSERT,UPDATE,DELETE ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
EOF

if [ -e backup.sql ]; then
    SQLFILE=backup.sql
else
    SQLFILE=initdb.sql
fi
docker exec -i $DBCONT_NAME mysql $MYSQL_DATABASE < $SQLFILE
