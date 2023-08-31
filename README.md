# ROS on Docker 

This script is used to launch a Docker container with ROS (Robot Operating System) installed, along with specified packages, using the provided Docker image.
Prerequisites

    Docker must be installed on your system.

Usage

bash

./launch_ros_docker.sh [OPTIONS]

Replace ./launch_ros_docker.sh with the actual path to the script.
Options

    --custom-image IMAGE_NAME: Specify a custom Docker image to use for the ROS container. If not provided, the default image "osrf/ros:noetic-desktop-full" will be used.
    --container-name NAME: Set a custom name for the Docker container. If not provided, the default name "ros-docker" will be used.

Additional Configuration

    APT_LIST File (Optional): You can create an apt_list.txt file in the same directory as the script to specify additional apt packages you want to install in the Docker container. Each package should be on a separate line. The script will read this file and install the listed packages.

Docker Container Setup

The following setup is performed when launching the Docker container:

    Interactive mode is enabled (-it flag).
    No file limit is set for the container (--ulimit nofile=524228:524228).
    Privileged mode is enabled (--privileged).
    All available GPUs are accessible from within the container (--gpus all).
    Environment variables required for X11 display are set (--env="DISPLAY" and --env="QT_X11_NO_MITSHM=1").
    The X11 socket is mounted to the container to enable GUI applications (--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw").
    The current directory on the host system is mounted to the /home directory in the container (--volume="$HOST_PATH:/home").
    /dev/video1 device is mounted to the container for video access (--device=/dev/video1:/dev/video1).
    Container restart policy is set to "always" (--restart=always).
    The container is named using the specified or default name (--name "$CONTAINER_NAME").

Finally, the Docker container runs a Bash shell within the specified Docker image. It updates the package list, installs the specified apt packages, and then starts an interactive shell.

Make sure to replace placeholders such as ./launch_ros_docker.sh with the actual script path and adjust any configurations to suit your needs.

Remember to also ensure that you have the necessary permissions to run Docker commands and access the required devices on your system.

Note: This documentation is based on the script's functionality up to the knowledge cutoff date in September 2021. If there have been any changes or updates to the script or its related technologies after that date, this documentation might not reflect those changes.
