FROM ghcr.io/linuxserver/baseimage-ubuntu:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
ARG CODIMD_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="chbmb"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV NODE_ENV production

RUN \
 echo "**** install build packages ****" && \
 apt-get update && \
 apt-get install -y \
	git \
	gnupg \
	jq \
	libssl-dev && \
 echo "**** install runtime *****" && \
 curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
 echo 'deb https://deb.nodesource.com/node_10.x bionic main' > /etc/apt/sources.list.d/nodesource.list && \
 echo "**** install yarn repository ****" && \
 curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
 echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
 apt-get update && \
 apt-get install -y \
	fontconfig \
	fonts-noto \
	netcat-openbsd \
	nodejs \
	yarn && \
 echo "**** install codi-md ****" && \
 if [ -z ${CODIMD_RELEASE+x} ]; then \
	CODIMD_RELEASE=$(curl -sX GET "https://api.github.com/repos/codimd/server/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]'); \
 fi && \
 curl -o \
 /tmp/codimd.tar.gz -L \
	"https://github.com/codimd/server/archive/${CODIMD_RELEASE}.tar.gz" && \
 mkdir -p \
	/opt/codimd && \
 tar xf /tmp/codimd.tar.gz -C \
	/opt/codimd --strip-components=1 && \
 cd /opt/codimd && \
 bin/setup && \
 npm run build && \
 echo "**** cleanup ****" && \
 yarn cache clean && \
 apt-get -y purge \
	git \
	gnupg \
	jq \
	libssl-dev && \
 apt-get -y autoremove && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ / 

# ports and volumes
EXPOSE 3000
VOLUME /config
