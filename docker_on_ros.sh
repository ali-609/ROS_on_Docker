#!/bin/bash

HOST_PATH=$(pwd)
APT_LIST="python3-catkin-tools"
GPU_FLAG=""
VIDEO_DEVICE="/dev/video1" # Default video device

# Check if apt_list.txt file exists
if [[ -f "./apt_list.txt" ]]; then
  APT_LIST=$(cat ./apt_list.txt | tr "\n" " ")
fi

DOCKER_IMAGE="osrf/ros:noetic-desktop-full"
CONTAINER_NAME="ros-docker"

HOST_UID=$(id -u)
HOST_GID=$(id -g)

# Define an array to hold valid flags
VALID_FLAGS=(
  "--custom-image"
  "--container-name"
  "--gpu"
  "--video"
)

# Function to display error message and exit
function display_error {
  echo "Error: Invalid flag or missing argument: $1"
  exit 1
}

# Parse command-line options
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    --custom-image)
      DOCKER_IMAGE="$2"
      shift # past argument
      shift # past value
      ;;
    --container-name)
      CONTAINER_NAME="$2"
      shift # past argument
      shift # past value
      ;;
    --gpu)  # added option to enable GPU
      GPU_FLAG="--gpus all"
      shift
      ;;
    --video)
      # Check if the next argument exists
      if [[ -n "$2" ]]; then
        VIDEO_DEVICE="/dev/$2"
        shift # past argument
        shift # past value
      else
        display_error "$key"
      fi
      ;;
    *)    # unknown option
      # Check if the unknown option starts with "--"
      if [[ "$key" == --* ]]; then
        display_error "$key"
      else
        # Handle non-flag arguments here, if needed
        shift
      fi
      ;;
  esac
done

docker run -it --ulimit nofile=524228:524228 --privileged $GPU_FLAG \
  --env="DISPLAY" \
  --env="QT_X11_NO_MITSHM=1" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  --volume="$HOST_PATH:/home" \
  --device="$VIDEO_DEVICE:$VIDEO_DEVICE" \
  --user "$HOST_UID:$HOST_GID" \
  --restart=always \
  --name "$CONTAINER_NAME" \
  "$DOCKER_IMAGE" \
  /bin/bash -c "apt-get update ; apt-get install -y $APT_LIST; exec /bin/bash"
