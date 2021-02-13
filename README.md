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
