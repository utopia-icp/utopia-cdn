#!/bin/bash

set -e

# This is the entry point of the node container (called by the docker daemon when starting the node container).
# It starts all the services of the node:
#  - orchestrator starting replica internally;
#  - replica's dependencies such as canister https outcalls adapter.

# Canister https outcalls

mkdir -p /workspace/ic-https-outcalls-adapter
echo '{
  "incoming_source": {
    "Path": "/workspace/ic-https-outcalls-adapter/socket"
  }
}' > /workspace/ic-https-outcalls-adapter/ic-canister-http-config.json
/usr/bin/ic-https-outcalls-adapter /workspace/ic-https-outcalls-adapter/ic-canister-http-config.json &

# Orchestrator (starting replica internally)

/usr/bin/orchestrator --ic-binary-directory /usr/bin --replica-binary-dir /usr/bin \
  --cup-dir /workspace/node \
  --replica-config-file /workspace/node/replica.json5 \
  --version-file /workspace/node/version.txt \
  --orchestrator-data-directory /workspace/node
