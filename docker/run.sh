#!/bin/sh

set -eu

export DOCKER_RUN_WS="$(dirname "$0")"
export DOCKER_DIR="$(dirname "$(readlink -f "$0")")"

# don't expose anything if DOCKER_EXPOSE is defined empty
if ! set | grep -q "^DOCKER_EXPOSE=\(''\)\?$"; then
	. "$DOCKER_RUN_WS/config.mk"

	: ${GODOC_PORT:=9090}
	: ${SERVER_PORT:=8080}

	if [ -z "${DOCKER_EXPOSE:-}" ]; then

		# special cases
		#
		case "${1:-}" in
		make)
			case "${2:-}" in
			doc)     DOCKER_EXPOSE="$GODOC_PORT" ;;
			run|dev) DOCKER_EXPOSE="$SERVER_PORT" ;;
			esac
			;;
		npm)
			case "${2:-}" in
			start) DOCKER_EXPOSE="$SERVER_PORT" ;;
			esac
			;;
		go)
			case "${2:-}" in
			run) DOCKER_EXPOSE="$SERVER_PORT" ;;
			esac
			;;
		ncu)
			;;
		*)
			DOCKER_EXPOSE="$SERVER_PORT $GODOC_PORT"
			;;
		esac

	fi

	for x in ${DOCKER_EXPOSE:-}; do

		case "$x" in
		*:*/*)	;;
		*/*)	x="${x%/*}:$x" ;;
		*)	x="$x:$x/tcp" ;;
		esac

		export DOCKER_EXTRA_OPTS="${DOCKER_EXTRA_OPTS:+$DOCKER_EXTRA_OPTS }-p $x"
	done

	export DOCKER_EXPOSE=
fi

exec docker-builder-run "$@"
