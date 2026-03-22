#!/bin/bash
set -e

if ! id -u "${FTP_USER}" >/dev/null 2>&1; then
    useradd -m -d /var/www/html -s /bin/bash "${FTP_USER}" || true
fi

echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd || true

chown -R "${FTP_USER}:${FTP_USER}" /var/www/html

echo "" >> /etc/vsftpd.conf

sed -i '/^pasv_address=/d' /etc/vsftpd.conf

echo "pasv_address=$(hostname -I | awk '{print $1}')" >> /etc/vsftpd.conf

exec /usr/sbin/vsftpd /etc/vsftpd.conf