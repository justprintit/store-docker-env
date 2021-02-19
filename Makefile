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
	@cd $(GOPATH); git ls-files -o bin/ pkg/ lib/ | grep -v ^pkg/mod | xargs -rt rm -rf
	go clean -x -r -modcache $(MODULES)
	-$(MAKE) -C src/$(MAIN_MODULE) clean

# fmt
#
fmt:
	find $(addprefix src/, $(MODULES)) -name '*.go' \
		| sed -e 's|/[^/]\+\.go$$||' -e 's|^src/||' \
		| sort -uV | xargs -r go fmt

# build
#
.PHONY: npm-build go-generate go-build

build: npm-build go-generate go-build

npm-build:
	cd src/$(MAIN_MODULE); npm run build

go-build:
	go get -v $(MAIN_MODULE)/...

go-generate:
	$(MAKE) -C src/$(MAIN_MODULE) go-generate

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
	@cd src/$(MAIN_MODULE) && godoc \
		-http=:$(GODOC_PORT) \
		-index -links=true
