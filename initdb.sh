#!/bin/sh

. ./.env

if [ ! -e initdb.sql ]; then
    docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql > initdb.sql
fi

docker exec -i $DBCONT_NAME mysql <<EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT SELECT,INSERT,UPDATE,DELETE ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
EOF

if echo "SELECT 1 FROM guacamole_user LIMIT 1" | docker exec -i $DBCONT_NAME mysql $MYSQL_DATABASE > /dev/null 2>&1; then
    echo "Database already initialized"
    echo "Recreate empty database with"
    echo " echo 'DROP DATABASE $MYSQL_DATABASE; CREATE DATABASE $MYSQL_DATABASE' | docker exec -i guacamole-docker_db_1 mysql"
else
    if [ -e backup.sql ]; then
        SQLFILE=backup.sql
        echo "Initializing database from $SQLFILE"
    else
        SQLFILE=initdb.sql
        echo "Initializing database, login with guacadmin:guacadmin and change the password"
    fi
    docker exec -i $DBCONT_NAME mysql $MYSQL_DATABASE < $SQLFILE
fi
