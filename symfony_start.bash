#!/bin/bash


# PART 1 / INSTALLATION
# 	- PHP and PHP-extensions
# 	- Composer
# 	- Symfony

# Install PHP 7.3 and extensions on Ubuntu 18.04
apt-get update
apt-get install software-properties-common -y --no-install-recommends
add-apt-repository ppa:ondrej/php -y
apt-get install -y --no-install-recommends \
php7.3 \
php7.3-fpm \
php7.3-mbstring \
php7.3-bcmath \
php7.3-xml \
php7.3-xmlrpc \
php7.3-zip \
php7.3-sqlite3 \
php7.3-mysql \
php7.3-pgsql \
php7.3-imap \
php7.3-readline \
php7.3-phpdbg \
php7.3-curl \
php7.3-intl \
php7.3-dev \
php-pear \
php-ssh2 \
php-yaml \
php-memcached \
php-redis \
php-apcu \
php-xdebug \
php-xhprof \
curl \
unzip
apt-get autoremove -y && apt-get clean -y
rm -rf /tmp/* /var/tmp/* /usr/share/doc/*
sed -i 's/;pcre.jit=1/pcre.jit=0/g' /etc/php/7.3/cli/php.ini
sed -i 's/;pcre.jit=1/pcre.jit=0/g' /etc/php/7.3/fpm/php.ini
sudo update-alternatives --set php /usr/bin/php7.3
sudo update-alternatives --set phar /usr/bin/phar7.3
sudo update-alternatives --set phar.phar /usr/bin/phar.phar7.3
sudo update-alternatives --set phpize /usr/bin/phpize7.3
sudo update-alternatives --set php-config /usr/bin/php-config7.3
echo "7.3" > ~/.php-version

# Install apache server
apt-get install -y \
apache2 \
libapache2-mod-php7.3 \
echo "AcceptFilter https none
AcceptFilter http none" >> /etc/apache2/apache2.conf
a2enmod php7.3

# Install composer (in bin directory)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'a5c698ffe4b8e849a443b120cd5ba38043260d5c4023dbf93e1558871f1f07f58274fc6f4c93bcfd858c6bd0775cd8d1') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --install-dir=bin --filename=composer
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer

# Install symfony
wget https://get.symfony.com/cli/installer -O - | bash
mv /home/$USER/.symfony/bin/symfony /usr/local/bin/symfony

# Configuration

sed -i 's/;date.timezone =/date.timezone = Europe\/Paris/g' /etc/php/7.3/cli/php.ini

# Check if installation completed successfully
symfony check:requirements

exit 1;

# PART 2 / SYMFONY PROJECT - GET STARTED
# 	- Create project
# 	- Generate entities from existing postgresql database

read -p "Enter the name of your new project: " PROJECT_NAME
symfony new $PROJECT_NAME --full
echo "7.3" > $PROJECT_NAME/.php-version

# Requirements
composer require symfony/apache-pack
composer require annotations


# Run server
symfony server:ca:install
symfony server:start --port=8080