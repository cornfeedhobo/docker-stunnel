FROM alpine:3.16

RUN set -ex && apk add --update stunnel

RUN set -ex && \
	mkdir /etc/stunnel/conf.d && \
	echo -e "\
$(grep -v -e '^\#' -e '^client' /etc/stunnel/stunnel.conf | grep .)\n\
include = /etc/stunnel/conf.d\n\
" > /etc/stunnel/stunnel.conf
