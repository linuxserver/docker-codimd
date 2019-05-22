[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)](https://linuxserver.io)

The [LinuxServer.io](https://linuxserver.io) team brings you another container release featuring :-

 * regular and timely application updates
 * easy user mappings (PGID, PUID)
 * custom base image with s6 overlay
 * weekly base OS updates with common layers across the entire LinuxServer.io ecosystem to minimise space usage, down time and bandwidth
 * regular security updates

Find us at:
* [Discord](https://discord.gg/YWrKVTn) - realtime support / chat with the community and the team.
* [IRC](https://irc.linuxserver.io) - on freenode at `#linuxserver.io`. Our primary support channel is Discord.
* [Blog](https://blog.linuxserver.io) - all the things you can do with our containers including How-To guides, opinions and much more!

# [linuxserver/codimd](https://github.com/linuxserver/docker-codimd)
[![](https://img.shields.io/discord/354974912613449730.svg?logo=discord&label=LSIO%20Discord&style=flat-square)](https://discord.gg/YWrKVTn)
[![](https://images.microbadger.com/badges/version/linuxserver/codimd.svg)](https://microbadger.com/images/linuxserver/codimd "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/linuxserver/codimd.svg)](https://microbadger.com/images/linuxserver/codimd "Get your own version badge on microbadger.com")
![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/codimd.svg)
![Docker Stars](https://img.shields.io/docker/stars/linuxserver/codimd.svg)
[![Build Status](https://ci.linuxserver.io/buildStatus/icon?job=Docker-Pipeline-Builders/docker-codimd/master)](https://ci.linuxserver.io/job/Docker-Pipeline-Builders/job/docker-codimd/job/master/)
[![](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/codimd/latest/badge.svg)](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/codimd/latest/index.html)

[Codimd](https://codimd.web.cern.ch/) gives you access to all your files wherever you are.

CodiMD is a real-time, multi-platform collaborative markdown note editor.  This means that you can write notes with other people on your desktop, tablet or even on the phone.  You can sign-in via multiple auth providers like Facebook, Twitter, GitHub and many more on the homepage.


[![codimd](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/codimd-icon.png)](https://codimd.web.cern.ch/)

## Supported Architectures

Our images support multiple architectures such as `x86-64`, `arm64` and `armhf`. We utilise the docker manifest for multi-platform awareness. More information is available from docker [here](https://github.com/docker/distribution/blob/master/docs/spec/manifest-v2-2.md#manifest-list) and our announcement [here](https://blog.linuxserver.io/2019/02/21/the-lsio-pipeline-project/). 

Simply pulling `linuxserver/codimd` should retrieve the correct image for your arch, but you can also pull specific arch images via tags.

The architectures supported by this image are:

| Architecture | Tag |
| :----: | --- |
| x86-64 | amd64-latest |
| arm64 | arm64v8-latest |
| armhf | arm32v7-latest |


## Usage

Here are some example snippets to help you get started creating a container.

### docker

```
docker create \
  --name=codimd \
  -e PUID=1000 \
  -e PGID=1000 \
  -e DATABASE_TYPE=sqlite \
  -e DATABASE_HOST=postgres \
  -e DATABASE_PORT=5432 \
  -e DATABASE_USER=postgres \
  -e DATABASE_PASSWORD=password \
  -e DOMAIN=codimd.server.com \
  -e CMD_${EXTRA_VARIABLE}=${VARIABLE} \
  -e TZ=Europe/London \
  -p 3000:3000 \
  -v </path/to/appdata>:/config \
  --restart unless-stopped \
  linuxserver/codimd
```


### docker-compose

Compatible with docker-compose v2 schemas.

```
---
version: "2"
services:
  codimd:
    image: linuxserver/codimd
    container_name: codimd
    environment:
      - PUID=1000
      - PGID=1000
      - DATABASE_TYPE=sqlite
      - DATABASE_HOST=postgres
      - DATABASE_PORT=5432
      - DATABASE_USER=postgres
      - DATABASE_PASSWORD=password
      - DOMAIN=codimd.server.com
      - CMD_${EXTRA_VARIABLE}=${VARIABLE}
      - TZ=Europe/London
    volumes:
      - </path/to/appdata>:/config
    ports:
      - 3000:3000
    restart: unless-stopped
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 3000` | If you wish to access this container from http://{IP}:${PORT}` this *must* be left unchanged. |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e DATABASE_TYPE=sqlite` | Type of database,  Only postgres and mysql are supported in future CodiMD database migrations, sqlite, mariadb will however work but are not guaranteed to in the future. |
| `-e DATABASE_HOST=postgres` | Host address of postgres/mysql/mariadb database (Omit for Sqlite) |
| `-e DATABASE_PORT=5432` | Port to access postgres/mysql/mariadb database (Omit for Sqlite) |
| `-e DATABASE_USER=postgres` | postgres/mysql/mariadb database user (Omit for Sqlite) |
| `-e DATABASE_PASSWORD=password` | postgres/mysql/mariadb database password (Omit for Sqlite) |
| `-e DOMAIN=codimd.server.com` | Domain where CodiMD will be acccessed. (Omit for Sqlite) |
| `-e CMD_${EXTRA_VARIABLE}=${VARIABLE}` | Optional CodiMD variable `CMD_${VARIABLE} See [here](https://hackmd.io/c/codimd-documentation/%2Fs%2Fcodimd-configuration) for details |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London. |
| `-v /config` | CodiMD config and configurable files |

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```


&nbsp;
## Application Setup

Due to the way CodiMD works, it is only possible to access via a domain name or if you keep the mapped port at `3000` so access the webui at `https://codimd.server.com` or `http://${IP}:3000/`.  Provided is a basic configuration to get things up and running, however you may include further environmental variables, as the example above, if your setup requires it, for more information check out the [CodiMD](https://hackmd.io/c/codimd-documentation/%2Fs%2Fcodimd-configuration) documentation.  Alternatively you can edit `/config/config.json` to provide a configuration option, an example of which can be found at `/config/config.json.example`.  Customisable [resources](https://hackmd.io/c/codimd-documentation/%2Fs%2Fcodimd-configuration) can be found in `/config/public`. 



## Support Info

* Shell access whilst the container is running: `docker exec -it codimd /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f codimd`
* container version number 
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' codimd`
* image version number
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/codimd`

## Updating Info

Most of our images are static, versioned, and require an image update and container recreation to update the app inside. With some exceptions (ie. nextcloud, plex), we do not recommend or support updating apps inside the container. Please consult the [Application Setup](#application-setup) section above to see if it is recommended for the image.  
  
Below are the instructions for updating containers:  
  
### Via Docker Run/Create
* Update the image: `docker pull linuxserver/codimd`
* Stop the running container: `docker stop codimd`
* Delete the container: `docker rm codimd`
* Recreate a new container with the same docker create parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
* Start the new container: `docker start codimd`
* You can also remove the old dangling images: `docker image prune`

### Via Docker Compose
* Update all images: `docker-compose pull`
  * or update a single image: `docker-compose pull codimd`
* Let compose update all containers as necessary: `docker-compose up -d`
  * or update a single container: `docker-compose up -d codimd`
* You can also remove the old dangling images: `docker image prune`

### Via Watchtower auto-updater (especially useful if you don't remember the original parameters)
* Pull the latest image at its tag and replace it with the same env variables in one run:
  ```
  docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower \
  --run-once codimd
  ```
* You can also remove the old dangling images: `docker image prune`

## Building locally

If you want to make local modifications to these images for development purposes or just to customize the logic: 
```
git clone https://github.com/linuxserver/docker-codimd.git
cd docker-codimd
docker build \
  --no-cache \
  --pull \
  -t linuxserver/codimd:latest .
```

The ARM variants can be built on x86_64 hardware using `multiarch/qemu-user-static`
```
docker run --rm --privileged multiarch/qemu-user-static:register --reset
```

Once registered you can define the dockerfile to use with `-f Dockerfile.aarch64`.

## Versions

* **23.05.19:** - Initial release
