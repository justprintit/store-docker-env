#!/bin/sh

set -eu

export DOCKER_RUN_WS="$(dirname "$0")"
export DOCKER_DIR="$(dirname "$(readlink -f "$0")")"

. "$DOCKER_RUN_WS/config.mk"

for x in ${SERVER_PORT:-} ${GODOC_PORT:-}; do
	export DOCKER_EXTRA_OPTS="${DOCKER_EXTRA_OPTS:+$DOCKER_EXTRA_OPTS }-p $x:$x/tcp"
done

exec docker-builder-run "$@"
