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
      --dkg-interval-length 20 \\
      "$@"

# Copy the registry local store created by ic-prep into the individual nodes' directories so that
# every node has its own registry local store to which the node's orchestrator writes exclusively.

for ID in 1 2 3 4; do \
  cp -r "/out/ic_registry_local_store" "/out/node-${ID}/ic_registry_local_store"
done
rm -rf /out/ic_registry_local_store

# Generate the replica config

cd /workspace/node_config_generator
for ID in 1 2 3 4; do \
  cargo run --release > "/out/node-${ID}/replica.json5"
done

# Generate the initial payload for the registry canister

cd /workspace/registry_init_args_generator
cargo run --release -- --registry "/out/registry.proto" --out /out/registry_init.bin
