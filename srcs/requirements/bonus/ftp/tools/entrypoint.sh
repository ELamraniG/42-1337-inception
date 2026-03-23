#!/bin/bash
set -e

if ! id -u "${FTP_USER}" ; then
    useradd -m -d /var/www/html "${FTP_USER}"
    echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd
    chown -R "${FTP_USER}:${FTP_USER}" /var/www/html
fi

exec /usr/sbin/vsftpd /etc/vsftpd.conf
