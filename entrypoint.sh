#!/bin/bash

mkdir -p /var/log/supervisor /var/log/iaxmodem /var/log/efax /var/spool/fax/incoming

true > /etc/supervisor/conf.d/fax.conf

for config in /etc/iaxmodem/*; do
    [ -e "$config" ] || continue
    tty=$(basename "$config")
    export TTY="$tty"
    envsubst < /usr/local/share/supervisor-program.conf.template >> /etc/supervisor/conf.d/fax.conf
done

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
