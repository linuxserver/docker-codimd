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
     fontconfig \
     fonts-noto \
     git \
     jq \
     libssl-dev \
     python-minimal && \
  echo "**** install node ****" && \
  apt-get update && apt-get install -y \
  node-gyp \
  nodejs \
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
	"https://github.com/codimd/server/archive/master.tar.gz" && \
  mkdir -p \
	/opt/codimd && \
  tar xf /tmp/codimd.tar.gz -C \
	/opt/codimd --strip-components=1 && \
  cd /opt/codimd && \
  bin/setup && \
  npm run build && \
  echo "**** cleanup ****" && \
  yarn cache clean && \
  apt-get -y remove \
     git \
     jq && \
  apt-get -y autoremove && \
  rm -rf \
	  /root/.cache \
	  /tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 3000
VOLUME /config
