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
x-www-browser http://127.0.0.1:8380/guacamole
```

## Reverse proxy using apache2 or nginx

https://guacamole.apache.org/doc/gug/reverse-proxy.html

```apache
  # Guacamole: Port 8380
  RedirectPermanent "/guacamole" "/guacamole/"
  <Location /guacamole/>
    Require all granted
    ProxyPass        http://127.0.0.1:8380/guacamole/ flushpackets=on
    ProxyPassReverse http://127.0.0.1:8380/guacamole/
  </Location>
  <Location /guacamole/websocket-tunnel>
    Require all granted
    ProxyPass ws://127.0.0.1:8380/guacamole/websocket-tunnel
    ProxyPassReverse ws://127.0.0.1:8380/guacamole/websocket-tunnel
  </Location>
  SetEnvIf Request_URI "^/guacamole/tunnel" dontlog
```
