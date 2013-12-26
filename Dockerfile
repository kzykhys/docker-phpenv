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

# Add php user
RUN adduser --disabled-login --gecos 'PHP' php

# install phpenv
RUN cd /home/php; \
    su php -c "curl https://raw.github.com/CHH/phpenv/master/bin/phpenv-install.sh | bash"; \
    echo 'export PATH="/home/php/.phpenv/bin:$PATH"' >> /home/php/.bashrc; \
    echo 'eval "$(phpenv init -)"' >> /home/php/.bashrc; \
    cd /home/php/.phpenv; \
    su php -c "mkdir plugins"; \
    cd /home/php/.phpenv/plugins; \
    su php -c "git clone https://github.com/CHH/php-build.git"

# install php
# RUN su php -c "phpenv install 5.5"
# RUN su php -c "phpenv install 5.4"
# RUN su php -c "phpenv install 5.3"

ENV HOME /home/php

USER php
WORKDIR /home/php