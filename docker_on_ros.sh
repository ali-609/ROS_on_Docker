#!/bin/bash

HOST_PATH=$(pwd)
APT_LIST="python3-catkin-tools"

# Check if apt_list.txt file exists
if [[ -f "./apt_list.txt" ]]; then
  APT_LIST=$(cat ./apt_list.txt | tr "\n" " ")
fi

DOCKER_IMAGE="osrf/ros:noetic-desktop-full"
CONTAINER_NAME="ros-docker"

# Parse command-line options
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    --docker-image)
      DOCKER_IMAGE="$2"
      shift # past argument
      shift # past value
      ;;
    --container-name)
      CONTAINER_NAME="$2"
      shift # past argument
      shift # past value
      ;;
    *)    # unknown option
      shift
      ;;
  esac
done

docker run -it --ulimit nofile=524228:524228 --privileged --gpus all \
  --env="DISPLAY" \
  --env="QT_X11_NO_MITSHM=1" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  --volume="$HOST_PATH:/home" \
  --device=/dev/video1:/dev/video1 \
  --restart=always \
  --name "$CONTAINER_NAME" \
  "$DOCKER_IMAGE" \
  /bin/bash -c "apt-get update ; apt-get install -y $APT_LIST; exec /bin/bash"