PetaLinux Tools Containerization
========================================
This enables you to make containerized PetaLinux Tools.

Requirements
----------------------------------------
- PetaLinux Tools installer file
    (e.g. `petalinux-v20xx.x-final-installer.run`).
- Docker Host Environment
  - Docker Engine
  - Docker Compose(18.06.0+, which works with Compose file format 3.7)

How to Build Container Images
----------------------------------------

### Step 1: Place a PetaLinux Tools installer file
```sh
$ git clone /path/to/this/repo
$ cd repo
$ mv /path/to/petalinux-v20xx.x-final-installer.run .
$ chmod a+r petalinux-v20xx.x-final-installer.run
```

### Step 2: Start a HTTP server that provides the installer while building
```sh
$ docker-compose -f docker-compose.ext.yml up -d repository
```

### Step 3: Run a build command
```sh
$ docker-compose -f docker-compose.yml -f docker-compose.ext.yml build
```
This, by default, builds the images, `petalinux:2019.2-original`and
`petalinux:2019.2-slim`, given that the installer for v2019.2 has been placed.
It takes 1 or 2 hour(s) to build images.
Additional hours may be required, depending on the performance of
your network environment.

If you prefer to build them with other revisions of PetaLinux Tools,
run the build command like(e.g. with v2018.2):
```sh
$ PETALINUX_VER=2018.2 docker-compose -f docker-compose.yml -f docker-compose.ext.yml build
```
or, run the previous build command after update [.env](.env) directly.

### Step 4: Stop the HTTP server, that is no longer required
```sh
$ docker-compose -f docker-compose.ext.yml down
```

How to Start Built Container
----------------------------------------

### Case 1: Starting Bash interactive shell
If you want to work with Bash interactive shell, run the following command.
```sh
$ docker-compose run --rm petalinux
```
This starts a interactive `bash` process on a container based on
the image `petalinux-20xx.x-slim`, by default `2019.2`.
The started `bash` process is configured, prior to interaction with you,
so that PetaLinux Tools commands(e.g. `petalinux-config`) are available.

### Case 2: Starting PetaLinux Tools commands directly
If you want to use PetaLinux Tools commands directly on the command line
within Docker host environment, add the command simply to the command line.
```sh
$ docker-compose run --rm petalinux petalinux-config
```

Future Work
----------------------------------------
- [ ] shrink container image size
- [ ] solve [incompatibility issue between Ubuntu 18.04 and Python 3.5](https://forums.xilinx.com/t5/Embedded-Linux/PetaLinux-build-fails-with-locale-errors-How-to-disable-locale/m-p/894431/highlight/false#M28960)
- [ ] make tftp available

<!-- vim: set expandtab : -->
