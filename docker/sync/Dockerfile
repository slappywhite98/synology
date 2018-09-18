FROM alpine:latest

RUN apk add --no-cache \ 
      bash \
      lftp \
      ca-certificates \ 
      openssh

COPY scripts/ /usr/local/bin/

VOLUME /downloads /config

ENTRYPOINT [ "/usr/local/bin/lftpsync.sh" ]