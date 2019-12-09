#!/bin/sh

# env var prod
if [ -f /etc/profile.d/picpay-env.sh ]; then
    source /etc/profile.d/picpay-env.sh
fi

# env var prod
if [ -f /etc/profile.d/picpay-config.sh ]; then
    source /etc/profile.d/picpay-config.sh
fi

# log
mkdir -p /app/storage/logs
rm -f /app/storage/logs/app.log
touch /app/storage/logs/app.log
chown -R www-data:www-data /app/storage

# supervisor
exec supervisord -c /etc/supervisord.conf