FROM lsiobase/ubuntu:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
ARG CODIMD_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="chbmb"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV NODE_VERSION="8.16.0"

RUN \
 echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y \
     build-essential \
     fonts-noto \
     git \
     jq \
     libssl-dev \
     python-minimal && \
 echo "**** install node ****" && \
  curl -o nodejs.deb https://deb.nodesource.com/node_8.x/pool/main/n/nodejs/nodejs_$NODE_VERSION-1nodesource1_amd64.deb && \
  dpkg -i ./nodejs.deb && \
  rm nodejs.deb && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get install -y \
     npm && \
 echo "**** install yarn ****" && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && \
  apt-get install -y \
     yarn && \
echo "**** install codi-md ****" && \
 if [ -z ${CODIMD_RELEASE+x} ]; then \
	CODIMD_RELEASE=$(curl -sX GET "https://api.github.com/repos/codimd/server/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]'); \
 fi && \
 curl -o \
	/tmp/codimd.tar.gz -L \
	"https://github.com/codimd/server/archive/$CODIMD_RELEASE.tar.gz" && \
 mkdir -p \
	/opt/codimd && \
 tar xf /tmp/codimd.tar.gz -C \
	/opt/codimd --strip-components=1 && \
 rm -f /opt/codimd/config.json \
 rm -f /opt/codimd/.sequelizerc \
 echo "**** install yarn packages ****" && \
  cd /opt/codimd && \
  yarn install --pure-lockfile && \
  yarn install --production=false --pure-lockfile && \
  npm run build && \
 echo "**** cleanup ****" && \
  yarn install && \
  yarn cache clean && \
  apt-get -y remove \
     build-essential \
     git \
     jq && \
  apt-get -y autoremove && \
  rm -rf \
	  /root/.cache \
	  /tmp/*

# add local files
#COPY root/ /

# ports and volumes
EXPOSE 3000
VOLUME /config