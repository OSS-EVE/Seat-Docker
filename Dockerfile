FROM ubuntu:latest

MAINTAINER Dan Pupius <dan@pupi.us>

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install software-properties-common

RUN add-apt-repository ppa:ondrej/php5-5.6 -y
RUN apt-get update

# Install apache, PHP, and supplimentary programs. curl and lynx-cur are for debugging the container.
RUN DEBIAN_FRONTEND=noninteractive apt-get -y --force-yes install apache2 libapache2-mod-php5 php5-mysql php5-gd php5-mcrypt php5-intl php-pear php-apc php5-curl curl lynx-cur supervisor mysql-client git

# Enable apache mods.
RUN a2enmod php5
RUN a2enmod rewrite

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini

WORKDIR /var/www/
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && hash -r
RUN composer create-project eveseat/seat seat --keep-vcs --prefer-source --no-dev

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

COPY seat_supervisor.conf /etc/supervisor/conf.d/seat.conf

WORKDIR /var/www/seat/

# This is for compliance until our pull request is merged
COPY dev/composer.json /var/www/seat/composer.json
COPY dev/app/Http/Kernel.php /var/www/seat/app/Http/Kernel.php
COPY dev/config/app.php /var/www/seat/config/app.php
COPY dev/config/trustedproxy.php /var/www/seat/config/trustedproxy.php
COPY dev/config/compile.php /var/www/seat/config/compile.php
RUN composer update
RUN php artisan vendor:publish

# copy settings
COPY env /var/www/seat/.env

# copy commands
COPY init.sh /var/www/seat/init.sh
COPY update.sh /var/www/seat/update.sh

COPY seat_apache.conf /etc/apache2/sites-enabled/000-default.conf

RUN chmod +x /var/www/seat/init.sh
RUN chmod +x /var/www/seat/update.sh

RUN chown -R www-data:www-data /var/www/seat
RUN chmod -R guo+w /var/www/seat/storage/

# doesnt work with some host filesystems...
#RUN supervisord -k -c /etc/supervisor/supervisord.conf

EXPOSE 80

CMD /usr/sbin/apache2ctl -D FOREGROUND