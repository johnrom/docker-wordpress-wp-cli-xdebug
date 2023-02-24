# Adds xDebug support to Conetix's docker-wordpress-wp-cli
# Docker Hub: https://registry.hub.docker.com/u/johnrom/docker-wordpress-wp-cli-xdebug/
# Github Repo: https://github.com/johnrom/docker-wordpress-wp-cli-xdebug

FROM wordpress:6.1.1-php8.1-apache
LABEL maintainer=docker@johnrom.com

# Add sudo in order to run wp-cli as the www-data user
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && apt-get install -q -y sudo less subversion mariadb-client

# Add WP-CLI
RUN curl -o /bin/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
COPY wp-su.sh /bin/wp
RUN chmod +x /bin/wp-cli.phar /bin/wp

RUN curl -Lo /tmp/phpunit.phar https://phar.phpunit.de/phpunit-10.phar \
    && chmod +x /tmp/phpunit.phar \
    && sudo mv /tmp/phpunit.phar /bin/phpunit

RUN yes | pecl install xdebug \
	&& docker-php-ext-enable xdebug

RUN yes | pecl install apcu \
	&& docker-php-ext-enable apcu

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
