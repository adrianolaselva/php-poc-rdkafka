FROM picpay/php:7.2-fpm-base

ENV newrelic_appname=event-tracking-api
ENV PECL_RBKAFKA_VERSION='3.0.5'
ENV LIB_RDKAFKA_VERSION='v0.11.6'

RUN apk --update add --no-cache php7-xdebug

COPY ./                        /app
COPY ./docker/config/         /

WORKDIR /app

# laravel install, chmod, others
RUN pecl install xdebug \
    && pecl install redis \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-enable redis \
    && composer dump-autoload -o -a \
    && chown -R www-data:www-data /var/tmp/nginx \
    && chmod +x /start.sh \
    && sed -i "s/NAME=\"/NAME=\"EventTracking/g" /etc/os-release \
    && apk --no-cache upgrade \
    && apk add autoconf git gcc g++ make bash \
    && git clone --depth 1 --branch ${LIB_RDKAFKA_VERSION} https://github.com/edenhill/librdkafka.git \
    && cd librdkafka \
    && ./configure \
    && make \
    && make install \
    && pecl install rdkafka-${PECL_RBKAFKA_VERSION} \
    && docker-php-ext-enable rdkafka \
    && cd ../ \
    && composer update

#RUN apk --no-cache upgrade \
#    && apk add autoconf git gcc g++ make bash

# Add lib rdkafka
#RUN git clone --depth 1 --branch ${LIB_RDKAFKA_VERSION} https://github.com/edenhill/librdkafka.git \
#    && cd librdkafka \
#    && ./configure \
#    && make \
#    && make install \
#    && pecl install rdkafka-${PECL_RBKAFKA_VERSION} \
#    && docker-php-ext-enable rdkafka \
#    && composer update

# NewRelic
#RUN \
#    mkdir -p /etc/default \
#    && curl -sS "https://download.newrelic.com/php_agent/archive/8.7.0.242/newrelic-php5-8.7.0.242-linux.tar.gz" | tar -C /tmp -zx \
#    && export NR_INSTALL_USE_CP_NOT_LN=1 \
#    && export NR_INSTALL_SILENT=1 \
#    && /tmp/newrelic-php5-*/newrelic-install install \
#    && cp /etc/newrelic/newrelic.cfg.template /etc/newrelic/newrelic.cfg \
#    && mkdir /lib64 \
#    && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

# entrypoint
ENTRYPOINT ["sh", "-c"]

# start
CMD ["/start.sh"]
