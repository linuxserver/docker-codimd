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
  -e DB_HOST=<hostname or ip> \
  -e DB_PORT=3306 \
  -e DB_USER=codimd \
  -e DB_PASS=<secret password> \
  -e DB_NAME=codimd \
  -e TZ=Europe/London \
  -p 3000:3000 \
  -v </path/to/appdata>:/config \
  --restart unless-stopped \
  linuxserver/codimd
```


### docker-compose

Compatible with docker-compose v2 schemas.

```
version: "3"
services:
  mariadb:
    image: linuxserver/mariadb:latest
    container_name: codimd_mariadb
    restart: always
    volumes:
      - <path to mariadb data>:/config
    environment:
      - MYSQL_ROOT_PASSWORD=<secret password>
      - MYSQL_DATABASE=codimd
      - MYSQL_USER=codimd
      - MYSQL_PASSWORD=<secret password>
      - PGID=1000
      - PUID=1000
      - TZ=Europe/London
  codimd:
    image: linuxserver/codimd:latest
    container_name: codimd
    restart: always
    depends_on:
      - mariadb
    volumes:
      - <path to config>:/config
    environment:
      - DB_HOST=mariadb
      - DB_USER=codimd
      - DB_PASS=<secret password>
      - DB_NAME=codimd
      - DB_PORT=3306
      - PGID=1000
      - PUID=1000
      - TZ=Europe/London
    ports:
      - "3000:3000"

```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 3000` | If you wish to access this container from http://{IP}:${PORT}` this *must* be left unchanged. |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e DB_HOST=<hostname or ip>` | Host address of mysql database |
| `-e DB_PORT=3306` | Port to access mysql database default is 3306 |
| `-e DB_USER=codimd` | Database user |
| `-e DB_PASS=<secret password>` | Database password |
| `-e DB_NAME=codimd` | Database name |
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

CodiMD web interface can be accessed `http://${IP}:3000/`, if you want to use a custom domain or anything besides port 3000 you will need to leverage their env settings for callbacks: (specifically for CMD_DOMAIN and CMD_URL_ADDPORT)

[Full list of CodiMD options](https://hackmd.io/c/codimd-documentation/%2Fs%2Fcodimd-configuration)

For convience we provide a working example using Mysql as a backend in this document, if you do not wish to use our custom environment values or a Mysql database backend feel free to leverage any of the settings laid out in the link above.

**NEED a section on how to run this behind a reverse proxy here env vars etc**



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
