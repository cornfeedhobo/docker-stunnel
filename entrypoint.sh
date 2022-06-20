#!/bin/ash
# shellcheck shell=dash
set -eu -o pipefail

# if running stunnel, wrap with tini and start watchdog process.
if [ "$1" = 'stunnel' ]; then
	if [ -n "$INOTIFYWAIT_ENABLED" ] && [ "$INOTIFYWAIT_ENABLED" = 1 ]; then
		# https://github.com/kubernetes/kubernetes/issues/24957#issuecomment-632881383
		INOTIFYWAIT_OPTS="${INOTIFYWAIT_OPTS:-"-e modify -e delete -e delete_self"}"
		if [ -z "$INOTIFYWAIT_FILES" ]; then
			printf 'INOTIFY_FILES must not be empty' >&2
			exit 1
		fi
		watch_certfile() {
			while true; do
				while [ ! -f "$1" ]; do
					echo "Waiting for '$1' to appear ..."
					sleep 1
				done

				echo "Waiting for '$1' to be deleted or modified..."
				# shellcheck disable=SC2086
				if ! inotifywait ${INOTIFYWAIT_OPTS} "$1"; then
					echo "WARNING: inotifywait exited with code $?"
				fi
				# small grace period before sending SIGHUP:
				sleep 1

				echo "Sending SIGHUP to stunnel"
				if ! pkill -HUP stunnel; then
					echo "WARNING: 'pkill' exited with code $?"
				fi
			done
		}
		for fn in ${INOTIFYWAIT_FILES}; do
			watch_certfile "$fn" &
		done
	fi
	set -- tini "$@"
fi

exec "$@"
