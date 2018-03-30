#!/bin/bash

# need supernode service information in order to operare
[ -z "$SUPERNODE_SERVICE_NAME" ] && { echo "Need to set SUPERNODE_SERVICE_NAME"; exit 1; }

# retrieve IP and port information from the supernode service
varName="${SUPERNODE_SERVICE_NAME}_SERVICE_HOST"
SUPERNODE_IP="${!varName}"
varName="${SUPERNODE_SERVICE_NAME}_SERVICE_PORT"
SUPERNODE_PORT="${!varName}"
[ -z "$SUPERNODE_IP" ] && { echo "Need to set SUPERNODE_IP"; exit 1; }
[ -z "$SUPERNODE_PORT" ] && { echo "Need to set SUPERNODE_PORT"; exit 1; }

echo "starting to watch supernode"
until nc -u -z $SUPERNODE_IP $SUPERNODE_PORT; do
    echo "waiting for supernode to be up"
    sleep 2
done
echo "supernode is up at $SUPERNODE_IP:$SUPERNODE_PORT"