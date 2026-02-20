#!/bin/sh
set -e

WP_PATH="/var/www/html"
SITE_URL="https://${DOMAIN_NAME}"

echo "WordPress init script started..."

# php -> php81
ln -sf /usr/bin/php81 /usr/local/bin/php

# Creer wp-config.php 
if [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo "Creating wp-config.php..."

    cp "$WP_PATH/wp-config-sample.php" "$WP_PATH/wp-config.php"

    sed -i "s/database_name_here/${MYSQL_DATABASE}/" "$WP_PATH/wp-config.php"
    sed -i "s/username_here/${MYSQL_USER}/" "$WP_PATH/wp-config.php"
    sed -i "s/password_here/${MYSQL_PASSWORD}/" "$WP_PATH/wp-config.php"
    sed -i "s/localhost/${MYSQL_HOSTNAME}/" "$WP_PATH/wp-config.php"

    echo "wp-config.php created."

    echo "Configuring Redis..." 

    echo "define('WP_REDIS_HOST', 'redis');" >> $WP_PATH/wp-config.php
    echo "define('WP_REDIS_PORT', 6379);" >> $WP_PATH/wp-config.php
    echo "define('WP_CACHE', true);" >> $WP_PATH/wp-config.php

    echo "Redis configured in wp-config.php"    
fi

echo "Waiting for MariaDB..."
while ! nc -z "$MYSQL_HOSTNAME" 3306 2>/dev/null; do
    sleep 1
done
echo "MariaDB is ready."

# Installer WordPress si pas encore fait
if ! /usr/bin/php81 /usr/local/bin/wp core is-installed --allow-root --path="$WP_PATH"; then
    echo "Installing WordPress..."

    /usr/bin/php81 /usr/local/bin/wp core install \
        --allow-root \
        --path="$WP_PATH" \
        --url="$SITE_URL" \
        --title="My Site" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL"

    echo "WordPress installed."

    # Проверяем и устанавливаем плагин Redis Object Cache
    if ! /usr/bin/php81 /usr/local/bin/wp plugin is-installed redis-cache --allow-root --path="$WP_PATH"; then
        echo "Installing Redis Object Cache plugin..."
        /usr/bin/php81 /usr/local/bin/wp plugin install redis-cache --activate --allow-root --path="$WP_PATH"
        echo "Plugin installed and activated."
    fi

    # Включаем кэш Redis
    /usr/bin/php81 /usr/local/bin/wp redis enable --allow-root --path="$WP_PATH"
    echo "Redis Object Cache enabled."

else
    echo "WordPress already installed."
fi

echo "Updating site URL to $SITE_URL..."

/usr/bin/php81 /usr/local/bin/wp option update home "$SITE_URL" --allow-root --path="$WP_PATH"
/usr/bin/php81 /usr/local/bin/wp option update siteurl "$SITE_URL" --allow-root --path="$WP_PATH"
/usr/bin/php81 /usr/local/bin/wp rewrite flush --allow-root --path="$WP_PATH"

# Set permissions for wp-content
mkdir -p $WP_PATH/wp-content/uploads
chown -R nobody:nobody $WP_PATH/wp-content
chmod -R 755 $WP_PATH/wp-content

echo "WordPress configuration complete."

echo "Starting PHP-FPM..."
exec php-fpm81 -F
