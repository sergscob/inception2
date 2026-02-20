#!/bin/sh
set -e

mkdir -p /var/lib/mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "!! Initializing database..."

    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    mysqld --user=mysql --skip-networking &

    echo "Waiting for MariaDB..."
    until mysqladmin ping --silent; do
        sleep 1
    done

    mysql -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF

    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
fi

echo "!! MariaDB ready"
exec mysqld --user=mysql --bind-address=0.0.0.0 --port=3306 --skip-networking=0
