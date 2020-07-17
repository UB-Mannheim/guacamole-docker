#!/usr/bin/env python3

import pymysql
import sys

env = {
    'host': 'localhost',
    'port': 33060,
}

with open('.env', 'r') as f:
    for l in f.readlines():
        tokens = l.strip().split('=')
        if len(tokens) > 2:
            tokens = tokens[0] + '='.join(tokens[1:])
        elif len(tokens) < 2:
            print("error reading .env")
            sys.exit(1)
        env[tokens[0]] = tokens[1]
        
connection = pymysql.connect(
    host=env['host'],
    port=env['port'],
    user=env['MYSQL_USER'],
    password=env['MYSQL_PASSWORD'],
    db=env['MYSQL_DATABASE']
)

try:
    with connection.cursor() as cursor:
        # get all connections using rdp
        sql = "SELECT `connection_id` from `guacamole_connection` WHERE `protocol` = 'rdp'"
        cursor.execute(sql)
        connection_ids = [ i[0] for i in cursor.fetchall() ]

        for c in connection_ids:
            sql = "SELECT * from `guacamole_connection_parameter` WHERE `connection_id` = %d AND `parameter_name` = 'security'" % c
            cursor.execute(sql)
            results = cursor.fetchall()
            if len(results):
                # id, name, value
                i, n, v = results[0]
                if v != 'rdp':
                    sql = "UPDATE `guacamole_connection_parameter` SET `parameter_value` = 'rdp' WHERE `connection_id` = %d AND `parameter_name` = 'security'" % i
                    print(sql)
                    cursor.execute(sql)
                else:
                    print("Connection %d is already up-to-date" % i)
            else:
                sql = "INSERT INTO `guacamole_connection_parameter` (`connection_id`, `parameter_name`, `parameter_value`) VALUES (%d, '%s', '%s')" % (c, 'security', 'rdp')
                print(sql)
                cursor.execute(sql)
        connection.commit()
            
        sql = "DESCRIBE `guacamole_connection_parameter`"
        cursor.execute(sql)
        for result in cursor.fetchall():
            print(result)
        
finally:
    connection.close()
