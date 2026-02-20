#!/bin/sh
set -e

deluser "$FTP_USER" 2>/dev/null || true

adduser -D -h /var/www/html "$FTP_USER"

echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

echo "Starting vsftpd..."
exec vsftpd /etc/vsftpd/vsftpd.conf
