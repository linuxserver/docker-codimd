# docker-codi-md

Still in testing

Docker run command

```
docker run -d \
--name='codimd' \
-e 'PUID'='99' \
-e 'PGID'='100' \
-e 'DATABASE_TYPE'='postgres' \
-e 'DATABASE_HOST'='${HOST-IP}' \
-e 'DATABASE_PORT'='${POSTGRES_PORT}' \
-e 'DATABASE_USER'='${POSTGRES_USER}' \
-e 'DATABASE_PASSWORD'='{POSTGRES_PASSWORD}' \
-e 'DOMAIN'='codimd.server.com' \
-p '3000:3000/tcp' \
-v '<path-to-data>/codi-md':'/config':'rw' \
'chbmb/codimd' 
```