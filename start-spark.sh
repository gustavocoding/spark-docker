#!/bin/bash

if [ -n "${MASTER_PORT_7077_TCP_ADDR}" ]; then
  /usr/local/spark/sbin/start-slave.sh spark://$MASTER_PORT_7077_TCP_ADDR:7077 --webui-port 9081 "$@"
else
  export SPARK_MASTER_IP=$(ip addr list eth0 |grep "inet " |cut -d' ' -f6|cut -d/ -f1)
  /usr/local/spark/sbin/start-master.sh --webui-port 9080 "$@"
  /usr/local/spark/sbin/start-slave.sh spark://$SPARK_MASTER_IP:7077 --webui-port 9081 "$@"
fi
