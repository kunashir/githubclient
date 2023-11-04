
FROM ruby:3.1.2-slim-buster

ARG RAILS_ENV

ENV RAILS_ENV=${RAILS_ENV:-staging}

# Configure bundler
ENV LANG=C.UTF-8 \
  BUNDLER_VERSION=2.3.26 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3 \
  RAILS_ROOT=/GitHubClient

# Common dependencies
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    curl \
    less \
    git \
    file \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

# Application dependencies
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    default-libmysqlclient-dev \
    imagemagick libmagickcore-dev libmagickwand-dev \
    vim \
    python-dev \
    openssh-client \
    postgresql-client libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && truncate -s 0 /var/log/*log


# Upgrade RubyGems and install required Bundler version
RUN gem update --system && \
  gem install bundler:${BUNDLER_VERSION}

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle config set force_ruby_platform true
RUN bundle install

RUN mkdir /var/run/puma/ && touch /var/run/puma/my_app.sock && mkdir /var/log/puma/ && touch /var/log/puma/puma.log

EXPOSE 3000

CMD puma -C $RAILS_ROOT/app/config/puma.rb
