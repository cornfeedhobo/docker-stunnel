#!/bin/ash
set -e

# if thrown flags immediately,
# assume they want to run the stunnel daemon
if [ "${1:0:1}" = '-' ]; then
	set -- stunnel "$@"
fi

# if running stunnel, wrap with tini
if [ "$1" = 'stunnel' ]; then
	set -- "$@" /etc/stunnel/stunnel.conf
fi

# otherwise, don't get in their way
exec "$@"
