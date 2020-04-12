# PetaLinux Tools Containerization
This enables you to make a containerized PetaLinux Tools.

## Prerequisites
- PetaLinux Tools installer file(e.g. `petalinux-v20xx.x-final-installer.run`).
- Docker Host Environment with...
  - Docker Engine
  - Docker Compose

## How to Build Containers

### Step 1: Place a PetaLinux Tools installer file.
```sh
$ git clone /path/to/this/repo
$ cd repo
$ mv /path/to/petalinux-v20xx.x-final-installer.run .
$ chmod a+r petalinux-v20xx.x-final-installer.run
```

### Step 2: Start a HTTP server that provides the installer file while building images.
```sh
$ docker-compose -f docker-compose.ext.yml up -d repository
```

### Step 3: Run a build command.
```sh
$ docker-compose -f docker-compose.yml -f docker-compose.ext.yml build
```
This, by default, builds the images, `petalinux:2019.2-original`and
`petalinux:2019.2-slim`, given that the installer for v2019.2 has been placed.
It takes 1 or 2 hour(s) to build images.
Additional hours may be required, depending on the performance of
your network environment.

If you want to build them with other revisions of PetaLinux Tools,
run the build command like(e.g. with v2018.2):
```sh
$ PETALINUX_VER=2018.2 docker-compose -f docker-compose.yml -f docker-compose.ext.yml build
```
or, run the first build command after modify [.env](.env) directly.

### Step 4: Stop the HTTP server, that is no longer required.
```sh
$ docker-compose -f docker-compose.ext.yml down
```

## How to Start Built Container
### Starting Bash interactive shell
If you want to work with Bash interactive shell, run the following command.
```sh
$ docker-compose run --rm petalinux
```
The started `bash` process is configured prior to interaction with you
so that PetaLinux Tools commands(e.g. `petalinux-config`) are available.

### Starting PetaLinux Tools commands directly
If you want to run PetaLinux Tools commands directly from Docker Host command line,
add the command simply the command line.
```sh
$ docker-compose run --rm petalinux petalinux-config
```

## Future Work
- [ ] shrink container image size
- [ ] make tftp available
