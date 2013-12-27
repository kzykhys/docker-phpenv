FROM ubuntu:latest

MAINTAINER Kazuyuki Hayashi hayashi@valnur.net

# update packages
RUN echo deb http://us.archive.ubuntu.com/ubuntu/ precise universe multiverse >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y upgrade

# install curl
RUN apt-get install -y curl

# install git
RUN apt-get install -y git

# install dependencies
RUN apt-get install -y build-essential libxml2-dev libssl-dev \
    libcurl4-gnutls-dev libjpeg-dev libpng12-dev libmcrypt-dev \
    libreadline-dev libtidy-dev libxslt1-dev autoconf \
    re2c bison

# add php user
RUN adduser --disabled-login --gecos 'PHP' php

# switch user to php
USER php
ENV HOME /home/php
WORKDIR /home/php

# install phpenv
RUN curl https://raw.github.com/CHH/phpenv/master/bin/phpenv-install.sh | bash
RUN echo 'export PATH="/home/php/.phpenv/bin:$PATH"' >> /home/php/.bashrc
RUN echo 'eval "$(phpenv init -)"' >> /home/php/.bashrc
RUN mkdir /home/php/.phpenv/plugins; \
    cd /home/php/.phpenv/plugins; \
    git clone https://github.com/CHH/php-build.git

# php-build-plugin-phpunit
RUN curl -o /home/php/.phpenv/plugins/php-build/share/php-build/after-install.d/phpunit \
    https://raw.github.com/CHH/php-build-plugin-phpunit/master/share/php-build/after-install.d/phpunit
RUN chmod +x /home/php/.phpenv/plugins/php-build/share/php-build/after-install.d/phpunit

ENV PATH /home/php/.phpenv/shims:/home/php/.phpenv/bin:$PATH
