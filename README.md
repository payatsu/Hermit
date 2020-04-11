# PetaLinux Containerization

## How to Build Containers

### 1. Place a PetaLinux Tools installer file to the current directory.
```sh
$ mv /path/to/petalinux-v20xx.x-final-installer.run .
```

### 2. Start a HTTP server that provides the installer file.
```sh
$ docker-compose -f docker-compose.ext.yml up -d repository
```

### 3. Run a build command.
```sh
$ docker-compose -f docker-compose.yml -f docker-compose.ext.yml build
```

### 4. Stop the HTTP server, that is no longer required.
```sh
$ docker-compose -f docker-compose.ext.yml down
```

## How to Start Built Container
```sh
$ docker-compose run --rm petalinux
```
