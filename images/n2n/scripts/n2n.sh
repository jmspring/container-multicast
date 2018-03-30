#!/bin/bash

FOREGROUND_FLAG=""
if [ ! -z "$FOREGROUND" ]; then
    if [ "$FOREGROUND" == "1" ]; then
        FOREGROUND_FLAG="-f"
    fi
fi

if [ "$MODE" == "supernode" ]; then
    [ -z "$SUPERNODE_PORT" ] && { echo "Need to set SUPERNODE_PORT"; exit 1; }

    # launch supernode process
    /usr/local/sbin/supernode -l $SUPERNODE_PORT -v $FOREGROUND_FLAG
elif [ "$MODE" == "edge" ]; then
    [ -z "$SUPERNODE_SERVICE_NAME" ] && { echo "Need to set SUPERNODE_SERVICE_NAME"; exit 1; }
    [ -z "$ENCRYPTION_KEY" ] && { echo "Need to set ENCRYPTION_KEY"; exit 1; }
    [ -z "$NETWORK_NAME" ] && { echo "Need to set NETWORK_NAME"; exit 1; }
    [ -z "$IPADDR_BASE" ] && { echo "Need to set IPADDR_BASE"; exit 1; }
    [ -z "$MACADDR_BASE" ] && { echo "Need to set MACADDR_BASE"; exit 1; }

    # retrieve IP and port information from the supernode service
    varName="${SUPERNODE_SERVICE_NAME}_SERVICE_HOST"
    SUPERNODE_IP="${!varName}"
    varName="${SUPERNODE_SERVICE_NAME}_SERVICE_PORT"
    SUPERNODE_PORT="${!varName}"
    [ -z "$SUPERNODE_IP" ] && { echo "Need to set SUPERNODE_IP"; exit 1; }
    [ -z "$SUPERNODE_PORT" ] && { echo "Need to set SUPERNODE_PORT"; exit 1; }

    # get node index
    EDGE_NODE_IDX=`hostname | awk -F"-" '{print $NF}'`
    let "EDGE_NODE_IDX+=1"

    # setup MAC address and IP address for edge instance
    MACADDR_NODE=`printf '%02X' "$EDGE_NODE_IDX"`
    MACADDR="$MACADDR_BASE:$MACADDR_NODE"
    IPADDR_NODE=$EDGE_NODE_IDX
    IPADDR="$IPADDR_BASE.$IPADDR_NODE"

    # setup TUN interface
    mkdir -p /dev/net
    if [ ! -c "/dev/net/tun" ]; then
        mknod /dev/net/tun c 10 200
    fi
    tunctl -t tun0

    # launch the edge process
    N2N_KEY="$ENCRYPTION_KEY" /usr/local/sbin/edge -v $FOREGROUND_FLAG -d n2n0 -c "$NETWORK_NAME" -m "$MACADDR" -a "$IPADDR" -l "$SUPERNODE_IP:$SUPERNODE_PORT"
else
    echo "MODE set incorrectly.  Should be 'edge' or 'supernode'"
    exit 1
fi