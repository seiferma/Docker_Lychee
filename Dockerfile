FROM php:apache

RUN apt-get update && \
    apt-get install --no-install-recommends -y imagemagick libmagickwand-dev libfreetype6 libfreetype6-dev libjpeg62-turbo libjpeg62-turbo-dev libzip-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/*

RUN pecl install imagick && \
    docker-php-ext-enable imagick && \
    docker-php-ext-configure gd --enable-gd-native-ttf --with-freetype-dir=/usr/include/freetype2 --with-png-dir=/usr/include --with-jpeg-dir=/usr/include && \
    docker-php-ext-install gd && \
    docker-php-ext-enable gd && \
    docker-php-ext-install mysqli && \
    docker-php-ext-install exif && \
    docker-php-ext-install zip

RUN apt-get remove -y libmagickwand-dev libfreetype6-dev libjpeg62-turbo-dev && \
    apt-get autoremove -y && \
    apt-get clean


ENV DATA_DIR=/var/www/html/data
ENV UPLOAD_DIR=/var/www/html/uploads

VOLUME ["${DATA_DIR}", "${UPLOAD_DIR}"]

RUN VERSION=3.2.7 && \
    curl -L -o /tmp/lychee.tar.gz "https://github.com/LycheeOrg/Lychee/archive/v$VERSION.tar.gz" && \
    tar -xvzf /tmp/lychee.tar.gz --strip-components 1 -C /var/www/html && \
    rm -rf $DATA_DIR/* && \
    rm -rf $UPLOAD_DIR/* && \
    chown root:root . && \
    chown -R www-data:www-data $DATA_DIR && \
    chown -R www-data:www-data $UPLOAD_DIR && \
    rm /tmp/lychee.tar.gz && \
    VERSION=

COPY upload-size.ini /usr/local/etc/php/conf.d/
COPY startLychee.sh /usr/local/bin/
ENTRYPOINT ["startLychee.sh"]
CMD ["apache2-foreground"]
