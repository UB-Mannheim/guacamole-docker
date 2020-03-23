#!/bin/sh

docker exec guacamole_db_1 mysqldump guacamole_db > backup.sql
