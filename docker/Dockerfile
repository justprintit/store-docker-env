# stage 1 - build fbec
#
FROM amery/docker-golang-builder:latest AS fbe

RUN apk --update --no-cache add \
		cmake \
		bash \
		bison \
		g++ \
		flex \
		libuuid \
		libexecinfo-dev \
		python3 py3-pip \
		util-linux-dev \
	&& pip3 install gil

RUN git clone https://github.com/karasz/FastBinaryEncoding /usr/src/fbe \
	&& cd /usr/src/fbe && gil update \
	&& cd /usr/src/fbe/build && ./unix.sh

# stage 2 - actual builder
#
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

# go generate
RUN apk --update --no-cache add \
	flatbuffers
COPY --from=fbe \
	/usr/src/fbe/bin/fbec /usr/bin/

# interactivity
#
RUN apk --update --no-cache add \
	bash \
	mandoc \
	tmux
