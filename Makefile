.PHONY: all clean fmt build dev run doc

all: build

# load customizations
#
include config.mk

MAIN_MODULE ?= github.com/amery/go-webpack-starter
EXTRA_MODULES ?=
MODULES = $(MAIN_MODULE) $(subst :, ,$(EXTRA_MODULES))

SERVER_PORT ?= 8080
GODOC_PORT ?= 9090

GOPATH := $(CURDIR)
GOBIN := $(GOPATH)/bin

# tools
#
DOCKER ?= $(shell which docker)

GO ?= go
GODOC ?= $(GOBIN)/godoc
GOFMT ?= gofmt
GOGET ?= $(GO) get -v

export GOPATH GOBIN GO GODOC GOFMT GOGET

# clean
#
clean:
	@git ls-files -o bin/ pkg/ lib/ | grep -v ^pkg/mod | xargs -rt rm -rf
	-$(MAKE) -C src/$(MAIN_MODULE) clean

# fmt
#
fmt:
	@find $(addprefix src/, $(MODULES)) -name '*.go' \
		| xargs -r $(GOFMT) -l -w -s
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
ifneq ($(DOCKER),)
.PHONY: pull
pull:
	sed -n -e 's|^[ \t]*FROM[ \t]\+\([^ ]\+\)[^ \t]*$$|\1|p' $(CURDIR)/docker/Dockerfile \
		| xargs -rt $(DOCKER) pull
endif

# doc
#
$(GODOC):
	$(GOGET) golang.org/x/tools/cmd/godoc

doc: $(GODOC)
	@echo "http://127.0.0.1:$(GODOC_PORT)"
	@env GO111MODULE=off $(GODOC) \
		-http=:$(GODOC_PORT) \
		-index -links=true

# update
#
.PHONY: update
update:
	git remote update --prune
	git submodule update --init --remote
