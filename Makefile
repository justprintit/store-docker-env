.PHONY: all clean fmt build dev run pull doc

all: build

# load customizations
#
include config.mk

MAIN_MODULE ?= github.com/amery/go-webpack-starter
EXTRA_MODULES ?=
MODULES = $(MAIN_MODULE) $(subst :, ,$(EXTRA_MODULES))

SERVER_PORT ?= 8080
GODOC_PORT ?= 9090

# clean
#
clean:
	@git ls-files -o bin/ pkg/ lib/ | grep -v ^pkg/mod | xargs -rt rm -rf
	-$(MAKE) -C src/$(MAIN_MODULE) clean

# fmt
#
fmt:
	find $(addprefix src/, $(MODULES)) -name '*.go' \
		| xargs -r gofmt -l -w
	-$(MAKE) -C src/$(MAIN_MODULE) fmt

# build
#
build:
	$(MAKE) -C src/$(MAIN_MODULE) build

# dev (run backend and webpack-dev-server)
# 
dev:
	$(MAKE) -C src/$(MAIN_MODULE) PORT=$(SERVER_PORT) dev

# run (run only backend)
#
run:
	$(MAKE) -C src/$(MAIN_MODULE) PORT=$(SERVER_PORT) run
	
# pull
#
pull:
	sed -n -e 's|^[ \t]*FROM[ \t]\+\([^ ]\+\)[^ \t]*$$|\1|p' $(CURDIR)/docker/Dockerfile \
		| xargs -rt docker pull

# doc
#
$(GOPATH)/bin/godoc:
	go get -v golang.org/x/tools/cmd/godoc

doc: $(GOPATH)/bin/godoc
	@echo "http://127.0.0.1:$(GODOC_PORT)"
	@env GO111MODULE=off godoc \
		-http=:$(GODOC_PORT) \
		-index -links=true
