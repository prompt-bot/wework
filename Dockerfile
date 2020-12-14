FROM alpine:3.12
LABEL maintainer="shaddock<hushuang123a@foxmail.com>"


RUN \
  sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
  apk add --no-cache \
    jq bash curl

ADD wework.sh /opt/wework.sh

CMD [ "/opt/wework.sh" ]
