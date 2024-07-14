#!/bin/bash

# This script is called by the orchestrator.

set -e

SCRIPT="$(basename "$0")[$$]"

write_log() {
    local message=$1

    if [ -t 1 ]; then
        echo "${SCRIPT} ${message}" >/dev/stdout
    fi
}

function usage() {
    cat <<EOF
Usage:
  manageboot.sh action

  Action is one of

    upgrade-install
      Uploads the upgrader container to the Docker daemon.
      The upgrader container must be given as a single .tar file.

    upgrade-commit
      Start upgrader container to install a new system version.
EOF
}

# Execute subsequent action
ACTION="$1"

shift

case "${ACTION}" in
    upgrade-install)
        if [ "$#" == 1 ]; then
            UPGRADER_IMG="${1}"
        else
            usage >&2
            exit 1
        fi

        write_log "Uploading upgrader container ${UPGRADER_IMG} with sha256 $(sha256sum "${UPGRADER_IMG}") to docker daemon"
        docker load -i "${UPGRADER_IMG}"

        # Get the sha256 hash of the upgrader container (NOT of its tarball)
        # and persist it in this container's local directory
        # for a latter invokation of the `upgrade-commit` command below.
        tar -xzf "${UPGRADER_IMG}"
        UPGRADER_SHA256="$(jq -r .[0].Config manifest.json  | sed "s/^blobs\/sha256\//sha256:/")"
        echo -n "${UPGRADER_SHA256}" > /workspace/upgrader_sha256.txt
        ;;

    upgrade-commit)
        if [ "$#" != 0 ]; then
            usage >&2
            exit 1
        fi

        # Starting the upgrader container that will in turn stop this node container and
        # start a new node container with an upgraded replica version.
        # We mount this node container's name into a separate file so that the upgrader container
        # can uniquely determine the old node container's name.
        UPGRADER_SHA256="$(cat /workspace/upgrader_sha256.txt)"
        docker run \
            --rm --init -d \
            -v "$(cat /cfg/cfg_dir.txt)/$(cat /cfg/node.txt)/node.txt:/workspace/old_node.txt" \
            -v "$(cat /cfg/cfg_dir.txt)/$(cat /cfg/node.txt)/node.txt:/workspace/node.txt" \
            -v "$(cat /cfg/cfg_dir.txt):/cfg" \
            -v "$(cat /cfg/out_dir.txt)/$(cat /cfg/node.txt):/out" \
            -v "/var/run/docker.sock:/var/run/docker.sock" \
                "${UPGRADER_SHA256}"
        ;;

    *)
        usage
        ;;
esac
