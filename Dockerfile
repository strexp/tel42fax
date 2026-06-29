FROM debian:stable-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    supervisor \
    gettext-base \
    iaxmodem \
    efax \
    libtiff-tools \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/supervisor/conf.d /var/log/supervisor /var/log/iaxmodem /var/log/efax /var/spool/fax/incoming

COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY supervisor-program.conf.template /usr/local/share/
COPY entrypoint.sh /usr/local/bin/
COPY fax-recv.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/fax-recv.sh

WORKDIR /var/spool/fax

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
