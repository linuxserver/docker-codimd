FROM lsiobase/alpine:3.9

# set version label
ARG BUILD_DATE
ARG VERSION
ARG CODIMD_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="chbmb"

# environment settings
ENV NODE_ENV production
ENV CMD_CONFIG_FILE=/config/config.json

RUN \
apk add --no-cache --virtual=build-dependencies \
     curl \
     g++ \
     git \
     jq \
     libressl-dev \
     make \
     python && \
  echo "**** install node ****" && \
  apk add --no-cache \
     fontconfig \
     font-noto \
     mc \
     nano \
     nodejs \
     npm \
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
  apk del --purge build-dependencies && \
  rm -rf \
	  /root/.cache \
	  /tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 3000
VOLUME /config
