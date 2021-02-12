FROM amery/docker-golang-builder:latest

# nodejs
#
LABEL docker-builder.version.nodejs="current"

LABEL docker-builder.run-env.npm="NPM_CONFIG_PREFIX"

RUN apk --update --no-cache add \
	nodejs-current \
	npm

RUN npm update && npm i -g \
	npm \
	npm-check-updates \
	&& rm -rf ~/.npm

COPY npm.sh /etc/entrypoint.d/

# interactivity
#
RUN apk --update --no-cache add \
	bash \
	mandoc
