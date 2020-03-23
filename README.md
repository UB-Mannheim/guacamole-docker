# guacamole-docker

docker-compose configuration and tools for running Apache Guacamole using Docker

## Run guacamole

```
# copy env.tmpl to proper filename and edit at least the DB password
cp env.tmpl .env
# run containers
docker-compose up -d
# initialize database
./initdb.sh
# open URL in browser
x-www-browser http://127.0.0.1:8080/guacamole
```

## Reverse proxy using apache2

Make sure to `a2enmod proxy_http`. Add the following to a suitable `VirtualHost` configuration:
```
ProxyPass        /guacamole http://127.0.0.1:8080/guacamole
ProxyPassReverse /guacamole http://127.0.0.1:8080/guacamole
```
