FROM php:7.4-apache
# Omeka-S web publishing platform for digital heritage collections (https://omeka.org/s/)
#MAINTAINER Sunny Patel <sunny.patel@monash.edu>

LABEL maintainer_name="Sunny Patel"
LABEL maintainer_email="sunny.patel@monash.edu"
LABEL maintainer_email2="sunny33p@gmail.com"

WORKDIR /var/www/html
# Install git ant and java
ARG version = 3.0.2
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
    git-core \
    apt-utils \
    unzip \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libmemcached-dev \
    zlib1g-dev \
    libzip-dev \
    zip \
    imagemagick
#Install php-extensions
RUN pecl install mcrypt-1.0.3
RUN docker-php-ext-enable mcrypt

RUN docker-php-ext-install -j$(nproc) iconv pdo pdo_mysql gd mysqli zip
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/

#Clone omeka-s - replace with git clone...
RUN rm -rf /var/www/html/*
ADD https://github.com/omeka/omeka-s/releases/download/v${version}/omeka-s-${version}.zip /tmp/omeka-s.zip
RUN unzip -d /tmp/ /tmp/omeka-s.zip && mv /tmp/omeka-s/* /var/www/html/ && rm -rf /tmp/omeka-s*
ADD https://raw.githubusercontent.com/omeka/omeka-s/develop/.htaccess.dist /var/www/html/.htaccess
#enable the rewrite module of apache
RUN a2enmod rewrite
#Create a default php.ini
COPY ./files/php.ini /usr/local/etc/php/

#Clone all the Omeka-S Modules
RUN cd /var/www/html/modules && curl "https://api.github.com/users/omeka-s-modules/repos?page=$PAGE&per_page=100" | grep -e 'git_url*' | cut -d \" -f 4 | xargs -L1 git clone
#Clone all the Omeka-S Themes
RUN cd /var/www/html/themes && rm -r default && curl "https://api.github.com/users/omeka-s-themes/repos?page=$PAGE&per_page=100" | grep -e 'git_url*' | cut -d \" -f 4 | xargs -L1 git clone
# copy over the database and the apache config
COPY database.py /var/www/html/database.py
#COPY ./files/database.ini /var/www/html/config/database.ini
COPY ./files/apache-config.conf /etc/apache2/sites-enabled/000-default.conf
COPY ./imagemagick-policy.xml /etc/ImageMagick/policy.xml
# set the file-rights
RUN chown -R www-data:www-data /var/www/html/
# RUN chown -R www-data:www-data /var/www/html/files
RUN chmod -R +w /var/www/html/files
VOLUME [ "/var/www/html/files" ]
# Expose the Port we'll provide Omeka on
EXPOSE 80
# Running Apache in foreground
CMD ["apache2-foreground"]

COPY docker-entrypoint.sh /var/www/html/docker-entrypoint.sh
RUN chmod 755 /var/www/html/docker-entrypoint.sh

ENTRYPOINT [ "/var/www/html/docker-entrypoint.sh" ]
