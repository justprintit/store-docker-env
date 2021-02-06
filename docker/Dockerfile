FROM amery/docker-golang-builder:latest

# nodejs
#
ENV NPM_VERSION="7.5.2"
ENV NCU_VERSION="11.1.1"

LABEL docker-builder.version.nodejs="current"
LABEL docker-builder.version.npm="$NPM_VERSION"
LABEL docker-builder.version.ncu="$NCU_VERSION"

LABEL docker-builder.run-env.npm=NPM_CONFIG_PREFIX

RUN apk --update --no-cache add \
	nodejs-current \
	npm

RUN npm update && npm i -g \
	npm@${NPM_VERSION} \
	npm-check-updates@${NCU_VERSION} \
	&& rm -rf ~/.npm

COPY npm.sh /etc/entrypoint.d/

# interactivity
#
RUN apk --update --no-cache add \
	bash
