#!/bin/bash

set -e

# This is the entry point of the prep container (called by the docker daemon when starting the prep container).
# It cleans up the node directory (containing the local registry store, keys, replicated state, and CUPs)
# and runs ic-prep to set up the node directory from scratch.

# Clean up the node directory

rm -rf /out/*

# Run ic-prep

ic-prep --working-dir /out \
      --replica-version "$(cat /workspace/version.txt)" \
      --provisional-whitelist /whitelist.json \
      --allow-empty-update-image \
      "$@"

# Copy the registry local store created by ic-prep into the individual nodes' directories so that
# every node has its own registry local store to which the node's orchestrator writes exclusively.

for NODE_DIR in $(find ./out -maxdepth 1 -mindepth 1 -type d -printf '%f\n'); do
  cp -r "/out/ic_registry_local_store" "/out/${NODE_DIR}/ic_registry_local_store"
  # Generate the replica config
  config > "/out/${NODE_DIR}/replica.json5"
done
rm -rf /out/ic_registry_local_store

# Generate the initial payload for the registry canister

registry-init-arg --registry "/out/registry.proto" --out /out/registry_init.bin
