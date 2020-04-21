Xilinx Tools Containerization
========================================
This enables you to make Docker container images of the following Xilinx tools.
- Vivado Design Suite HLx Editions(Vivado)
- Vitis Unified Software Platform(Vitis)
- PetaLinux Tools

Requirements
----------------------------------------
### Base Requirements
- Docker Host Environment
  - Docker Engine
  - Docker Compose(18.06.0+, which can work with Compose file format 3.7)

### Further Requirements for Vivado
- Vivado HLx 20xx.x: All OS installer Single-File(e.g. `Xilinx_Vivado_20xx.x_xxxx_xxxx.tar.gz`)

### Further Requirements for Vitis
- Xilinx Vitis 20xx.x: All OS installer Single-File(e.g. `Xilinx_Vitis_20xx.x_xxxx_xxxx.tar.gz`)

### Further Requirements for PetaLinux Tools
- PetaLinux 20xx.x installer(e.g. `petalinux-v20xx.x-final-installer.run`)

How to Build Container Images
----------------------------------------
### Step 1: Place one of the above installers you want to use
```sh
$ git clone /path/to/this/repo
$ cd repo

# for Vivado
$ mv /path/to/Xilinx_Vivado_20xx.x_xxxx_xxxx.tar.gz Xilinx_Vivado_20xx.x.tar.gz
$ chmod a+r Xilinx_Vivado_20xx.x.tar.gz

# for Vitis
$ mv /path/to/Xilinx_Vitis_20xx.x_xxxx_xxxx.tar.gz Xilinx_Vitis_20xx.x.tar.gz
$ chmod a+r Xilinx_Vitis_20xx.x.tar.gz

# for PetaLinux Tools
$ mv /path/to/petalinux-v20xx.x-final-installer.run .
$ chmod a+r petalinux-v20xx.x-final-installer.run
```
We have to grant 'others' read access to the installers, so that the file server
mensioned later can access the installers to serve them.
Therefore, the above `chmod` commands do so.

The names of the original installers for Vivado and Vitis contain numbers,
which seem to be release date and time. Because they could be cause of any troubles,
the above `mv` commands remove the numbers from the names, as well as move files.


### Step 2: Start a file server that provides the installers while building
```sh
$ docker-compose -f docker-compose.ext.yml up -d repository
```

### Step 3: Build container images

#### Build Vivado image
```sh
$ docker-compose -f docker-compose.yml -f docker-compose.ext.yml build vivado
```

#### Build Vitis image
```sh
$ docker-compose -f docker-compose.yml -f docker-compose.ext.yml build vitis
```

#### Build PetaLinux Tools image
```sh
$ docker-compose -f docker-compose.yml -f docker-compose.ext.yml build petalinux
```

#### Cleanup dangling images
```sh
$ docker image prune -f
```

#### Tips: How to build with other revisions

Each of the above build commands, by default, builds each corresponding
images with revisions specified in [.env](.env).
For example, `petalinux:2019.2-original` and `petalinux:2019.2-slim`
are built for PetaLinux Tools, as specified in [.env](.env), given that ofcourse
the installer for v2019.2 has been placed.

If you prefer to build each images with other revisions of the corresponding tools,
run the build command like(e.g. with PetaLinux Tools v2018.2):
```sh
$ PETALINUX_VER=2018.2 docker-compose -f docker-compose.yml -f docker-compose.ext.yml build petalinux
```
or, run the previous build command after update [.env](.env) directly.

#### Tips: Estimated build time
It takes 1 or 2 hour(s) to build images for PetaLinux Tools.
It may be longer than expected, depending on the network performance of your system.

### Step 4: Stop the file server, that is no longer required
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
### for All Tools
- [ ] shrink container image size
- [ ] make [Platform Cable USB II][cable] available within containers
### for Vivado
- [ ] incorporate/automate to apply license key
### for PetaLinux Tools
- [ ] solve [incompatibility issue between Ubuntu 18.04 and Python 3.5](https://forums.xilinx.com/t5/Embedded-Linux/PetaLinux-build-fails-with-locale-errors-How-to-disable-locale/m-p/894431/highlight/false#M28960)
- [ ] make tftp available

References
----------------------------------------
- [UG973 Vivado Design Suite User Guide - Release Notes, Installation, and Licensing][ug973]
- [UG1400 Vitis Unified Software Platform Documentation - Embedded Software Development][ug1400]
- [UG1144 PetaLinux Tools Documentation - Reference Guide][ug1144]
- [Xilinx の開発ツールを Docker コンテナに閉じ込める](https://blog.myon.info/entry/2018/09/15/install-xilinx-tools-into-docker-container/)

[ug973]: https://www.xilinx.com/support/documentation-navigation/see-all-versions.html?xlnxproducttypes=Design%20Tools&xlnxdocumentid=UG973
    "Vivado Design Suite User Guide - Release Notes, Installation, and Licensing"
[ug1400]: https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug1400-vitis-embedded.pdf
    "Vitis Unified Software Platform Documentation - Embedded Software Development"
[ug1144]: https://www.xilinx.com/support/documentation-navigation/see-all-versions.html?xlnxproducttypes=Design%20Tools&xlnxdocumentid=UG1144
    "PetaLinux Tools Documentation - Reference Guide"
[cable]: https://www.xilinx.com/products/boards-and-kits/hw-usb-ii-g.html "Platform Cable USB II"

<!-- vim: set expandtab : -->
