FROM alpine:3.3

ENV GOSU_VERSION 1.7

RUN apk --update add \
  bash ruby ruby-nokogiri git \
  build-base ruby-dev icu-dev zlib-dev && \
#  build-base libxml2-dev libxslt-dev icu-dev && \
#  gem install nokogiri --no-ri --no-rdoc -- --use-system-libraries && \
  gem install gollum github-markdown --no-ri --no-rdoc && \
  apk --purge del ruby-dev build-base icu-dev zlib-dev && \
  apk add icu zlib && \
  rm -rf /var/cache/apk/*

RUN addgroup gollum && \
  adduser -g "Gollum wiki" -s /bin/bash -D -H -G gollum gollum 

RUN curl -sSL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64" -o /usr/local/bin/gosu && \
  chmod +x /usr/local/bin/gosu

VOLUME ["/gollum/wiki.git"]

#RUN mkdir -p /gollum/wiki.git && \
#  cd /gollum/wiki.git && \
#  git init --bare

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

EXPOSE 4567

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["gollum"]
