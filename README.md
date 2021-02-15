# webstarter

Environment for building golang + npm applications

## Requirements

* docker
* `docker-builder-run` from [amery/docker-builder](https://github.com/amery/docker-builder)

## Usage

This module assumes you have `docker-builder-run` installed and its `x` command on `$PATH`.
`x` will find the `./run.sh` to run whatever you call inside the building environment.

first pull the latest base build image
```
$ make pull
```

and from now either work within the building, getting a shell just calling `x`
```
~/somewhere$ x
abcdef012345:~/somewhere
```

or executing via `x`
```
~/somewhere: x make run
```

## Customizing

Key variables are defined by `config.mk` which shall remain sh and `make` compatible

## Exposing Ports

By default `x` will expose `SERVER_PORT` and `GODOC_PORT` as defined by `config.mk`,
or falling back to 8080 and 9090 correspondingly if undefined.

To prevent `x` from exposing any port, export an empty `DOCKER_EXPOSE` variable
```
$ export DOCKER_EXPOSE=
$ x
```

There are also two special cases if `DOCKER_EXPOSE` hasn't been disabled.
when calling `x make doc` it will only expose `GODOC_PORT`, or 9090/tcp if undefined,
and when calling `x make dev` or `x make run` it will expose `SERVER_PORT`, or 8080/tcp if undefined,
and every other extra port specified via `DOCKER_EXPOSE`.
