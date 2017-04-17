FROM ruby:2.4.1-alpine

LABEL maintainer="https://github.com/ailispaw/mastodon" \
      description="A GNU Social-compatible microblogging server"

ENV RAILS_ENV=production \
    NODE_ENV=production

EXPOSE 3000 4000

WORKDIR /mastodon

RUN echo "@edge https://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    apk --no-cache --update add \
      nodejs@edge \
      nodejs-npm@edge \
      libpq \
      libxml2 \
      libxslt \
      ffmpeg \
      file \
      imagemagick@edge

COPY Gemfile Gemfile.lock package.json yarn.lock /mastodon/

RUN apk --no-cache --update add \
      --virtual build-deps postgresql-dev libxml2-dev libxslt-dev build-base && \
    npm install -g yarn && \
    bundle install --deployment --without test development && \
    yarn --ignore-optional && \
    yarn cache clean && \
    npm -g cache clean && \
    apk del build-deps && \
    rm -rf /tmp/*

COPY . /mastodon

VOLUME /mastodon/public/system /mastodon/public/assets

CMD [ "sh" ]
