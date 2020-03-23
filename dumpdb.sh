#!/bin/sh

. ./.env

docker exec $DBCONT_NAME mysqldump $MYSQL_DATABASE > backup.sql
