#!/bin/bash

set -e

# This is the entry point of the HTTP gateway container (called by the docker daemon when starting the HTTP gateway).
# It starts all the services of the HTTP gateway:
#  - the PocketIC server;
#  - the HTTP gateway.

REPLICA_URL="${1}"

# PocketIC server: bind the server at port 8000

rm -f pocket-ic.port
pocket-ic --port 8000 --ttl 2592000 --port-file pocket-ic.port &
while [ ! -f pocket-ic.port ]
do
  sleep 1
done

# Start an HTTP gateway at port 8080

curl -X POST -H "Content-Type: application/json" http://localhost:8000/http_gateway -d "{\"listen_at\": 8080, \"forward_to\": {\"Replica\": \"${REPLICA_URL}\"}, \"domain\": \"localhost\"}"

# Block until the HTTP gateway container is killed

while [ true ]
do
  sleep 1
done
