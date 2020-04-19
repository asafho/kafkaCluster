#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
set -e

status=$(service kafka status | grep Active)
date=$(date)

if [[ "$status" == *"running"* ]]; then
  echo "$date kafka is active"
else
  echo "$date kafka is not active"
  echo "$date restarting service..."
  sudo service zookeeper restart
  sleep 15
  sudo service kafka restart
fi
