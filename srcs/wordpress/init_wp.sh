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

    # Second user
    SECOND_USER_LOGIN="${WP_SECOND_USER:-editor}"
    SECOND_USER_PASS="${WP_SECOND_USER_PASSWORD:-editor123}"
    # SECOND_USER_PASS=$(cat /run/secrets/wp_second_user_password)
    SECOND_USER_EMAIL="${WP_SECOND_USER_EMAIL:-editor@example.com}"
    SECOND_USER_ROLE="${WP_SECOND_USER_ROLE:-editor}"

    # Check if the second user already exists 
    if ! /usr/bin/php81 /usr/local/bin/wp user get "$SECOND_USER_LOGIN" --allow-root --path="$WP_PATH" >/dev/null 2>&1; then
        echo "Creating second user: $SECOND_USER_LOGIN..."
        /usr/bin/php81 /usr/local/bin/wp user create \
            "$SECOND_USER_LOGIN" "$SECOND_USER_EMAIL" \
            --user_pass="$SECOND_USER_PASS" \
            --role="$SECOND_USER_ROLE" \
            --allow-root \
            --path="$WP_PATH"
        echo "Second user created."
    else
        echo "Second user $SECOND_USER_LOGIN already exists."
    fi


    #  Redis Object Cache
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
