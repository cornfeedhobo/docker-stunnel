FROM alpine:3.16

RUN set -ex && apk add --no-cache --update \
		ca-certificates \
		inotify-tools \
		procps \
		stunnel \
		tini

COPY entrypoint.sh /entrypoint.sh

RUN set -ex && \
	chmod +x /entrypoint.sh && \
	mkdir /run/stunnel && \
	mkdir /etc/stunnel/{conf,tls}.d && \
	echo -e "\
foreground = yes\n\
syslog = no\n\
$(grep -v -e '^\#' -e '^client' -e '^pid' /etc/stunnel/stunnel.conf | grep .)\n\
include = /etc/stunnel/conf.d\n\
" > /etc/stunnel/stunnel.conf

ENV INOTIFYWAIT_ENABLED=0

ENTRYPOINT ["/entrypoint.sh"]

CMD ["stunnel", "/etc/stunnel/stunnel.conf"]
