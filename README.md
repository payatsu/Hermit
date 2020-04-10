# PetaLinux Containerization

# How to Build

```sh
$ docker-compose -f docker-compose.build.yml up -d repository
$ docker-compose -f docker-compose.yml -f docker-compose.build.yml build
$ docker-compose -f docker-compose.build.yml down
```

# How to Start a Container

```sh
$ docker-compose run --rm petalinux
```
