FROM jupyter/minimal-notebook

USER root

ENV DEBIAN_FRONTEND noninteractive

COPY install-composer.sh /tmp

RUN cd /tmp \
    && apt-get update \
    && apt-get install -yq --no-install-recommends \
        apt-utils \
        curl \
        pkg-config \
        software-properties-common \
    && LANG=C.UTF-8 add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -yq --no-install-recommends \
        libzmq3-dev \
        php-pear \
        php7.2-bcmath \
        php7.2-bz2 \
        php7.2-cli \
        php7.2-common \
        php7.2-curl \
        php7.2-dev \
        php7.2-gd \
        php7.2-gmp \
        php7.2-intl \
        php7.2-json \
        php7.2-mbstring \
        php7.2-mysql \
        php7.2-pgsql \
        php7.2-readline \
        php7.2-soap \
        php7.2-sqlite3 \
        php7.2-tidy \
        php7.2-xml \
        php7.2-xmlrpc \
        php7.2-xsl \
        php7.2-zip \
        php-zmq \
    && chmod 0755 install-composer.sh && ./install-composer.sh \
    && chmod 0755 composer.phar && mv composer.phar /usr/bin/composer \
    && curl -s -L -O "https://litipk.github.io/Jupyter-PHP-Installer/dist/jupyter-php-installer.phar" \
    && curl -s -L -O "https://litipk.github.io/Jupyter-PHP-Installer/dist/jupyter-php-installer.phar.sha512" \
    && shasum -s -a 512 -c jupyter-php-installer.phar.sha512 \
    && php jupyter-php-installer.phar install \
    && rm -rf /tmp/*

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_USER
