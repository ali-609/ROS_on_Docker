# ROS on Docker 

This script is used to launch a Docker container with ROS (Robot Operating System) installed, along with specified packages, using the provided Docker image.

## Prerequisites

### Docker
Docker provides isolated environments for Linux systems called containers. Containers use the same kernel drivers as the host system and are capable of using system memory. However, docker containers use their own binaries and file systems. That solves general dependency problems of applications and makes everything portable. That is our case here. By using ROS in Docker, it is possible to use ROS in other Linux distros like Fedora, Arch Linux, or even with different versions of Ubuntu.

The nicely done install and post-install instructions are provided in the official documentation.  \
Ubuntu and Debian install: https://docs.docker.com/engine/install/debian/   \
Fedora install: https://docs.docker.com/engine/install/fedora/     \
Post-install steps (for all Linux versions): https://docs.docker.com/engine/install/linux-postinstall/   

### Nvidia-docker or Nvidia-container (optional)
These packages make it possible for docker containers to interact with Nvidia GPUs. If you have no Nvidia GPU or integrated GPU enough, there is no need to install these packages.


## Usage

### Creating container

The provided script binds it's located directory with /home directory in the container environment. This directory serves as our main catkin workspace. 

```console
$ cd /path/to/script
$ ./launch_ros_docker.sh [OPTIONS]
```




    
    Options:
    --custom-image IMAGE_NAME : Specify a custom Docker image to use for the ROS container. If not provided, the default image "osrf/ros:noetic-desktop-full" will be used.
    --container-name NAME : Set a custom name for the Docker container. If not provided, the default name "ros-docker" will be used.
    --gpu: If packages for Nvidia GPU is installed provide GPU capabilities to container.


APT_LIST File: You can add apt packages to apt_list.txt file in the same directory as the script to specify additional packages you want to install in the Docker container. Each package should be on a separate line. The script will read this file and install the listed packages.
### Accessing container
Generally, the below command is used to access containers.
```console
$ docker exec -it [container_name] /bin/bash
```

In our case, the default container name is 'ros-docker':
```console
$ docker exec -it ros-docker /bin/bash
```
### Navigating inside container
In order use ROS commands we first need to source:
```console
# source ros_entrypoint.sh
```
As script bind /home with host operating system catkin work space need to be created that folder
```console
# cd /home
# mkdir src
# catkin build
```

### Enabling graphical capabilities
The provided script generates container graphical capabilities even without Nvidia GPU libraries. However, in order to operate we first need to allow permission on host operating system:
```console
$ xhost + local:docker
```
### Handling version control
For version control as our script bind folder from host system with container we can just use host system to access files and use git operations



## Troubleshooting

### Camera not working
In Linux systems, everything is a file that includes peripherals like cameras. Given script bind /dev/camera1 file of the host system with /dev/camera1 of the container system. If you have some loopback device like v4l2loopback or a similar module, try removing it and trying again.

