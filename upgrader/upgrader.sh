#!/bin/bash

set -e

# This is the entry point of the upgrader container (called by the docker daemon when starting the upgrader container).
# It stops the old node container and starts a new node container with an upgraded replica version.

# Fetch configuration parameters stored in files mounted from the host.

CONTAINER_NAME="$(cat /workspace/node.txt)"
OUT_DIR="$(cat /cfg/${CONTAINER_NAME}/out_dir.txt)"
CFG_DIR="$(cat /cfg/${CONTAINER_NAME}/cfg_dir.txt)"

# Make permissions more restrictive
chmod o-rwx -R "${OUT_DIR}/${CONTAINER_NAME}"

# Stop the old node container if one exists

if [ -f "/workspace/old_node.txt" ]
then
  OLD_CONTAINER_NAME="$(cat /workspace/old_node.txt)"

  docker stop "${OLD_CONTAINER_NAME}"

  while "$(docker container inspect -f '{{.State.Running}}' "${OLD_CONTAINER_NAME}")"
  do
    sleep 1
  done

  docker rm "${OLD_CONTAINER_NAME}"
fi

# Upload the new node container to docker daemon

docker load -i "/workspace/node.tar"

# Get the sha256 hash of the new node container (NOT of its tarball)

tar -xf "/workspace/node.tar"
NODE_SHA256="$(jq -r .[0].Config manifest.json | sed "s/^blobs\/sha256\//sha256:/")"

# Persist the new replica version in a version file shared with the host
# to be picked up by the new node container.

cp /workspace/version.txt /out/version.txt

# Start the new node container with an upgraded replica version.

docker run \
      --init -d \
      --name "${CONTAINER_NAME}" \
      --network host \
      -w /workspace \
      -v "${OUT_DIR}/${CONTAINER_NAME}:/workspace/node" \
      -v "${CFG_DIR}/${CONTAINER_NAME}:/cfg" \
      -v "/var/run/docker.sock:/var/run/docker.sock" \
      "${NODE_SHA256}"
