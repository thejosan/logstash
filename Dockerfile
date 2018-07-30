FROM alpine:3.8
MAINTAINER josan <704504886@qq.com>

ENV LOGSTASH_VERSION=5.6.5
COPY run.sh /tmp/
ENV ES_URL=192.168.1.1:9200

RUN set -x \
 && apk add --update bash curl tar openssl \ 
 && apk --no-cache add ca-certificates \
 && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub \
 && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk \
 && apk add glibc-2.23-r3.apk \
 
 && curl -L -O https://artifacts.elastic.co/downloads/logstash/logstash-${LOGSTASH_VERSION}.tar.gz \
 && tar xzvf logstash-${LOGSTASH_VERSION}.tar.gz -C / --strip-components=1 \
 && rm -rf logstash-${LOGSTASH_VERSION}.tar.gz \
 && ln -s /logstash /bin/logstash \
 && cp /tmp/run.sh /run.sh \
# && cat /tmp/grok.conf > /grok.conf \
 && sed -i "s/yourlogstashurl/$LOGSTASH_URL/g" /logstash.yml \

 
 && rm -rf /glibc-2.23-r3.apk \
 && rm -rf /tmp/* \ 
 && apk del curl tar openssl \
 && rm -rf /var/cache/apk/* 
 
 CMD /bin/bash /run.sh
 
