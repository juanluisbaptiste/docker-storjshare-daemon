#!/bin/bash
#Strip double quotes if added on env var
STORJ_CONFIG_FILE="${STORJ_CONFIG_FILE%\"}"
STORJ_CONFIG_FILE="${STORJ_CONFIG_FILE#\"}"

if [ -f ${STORJ_CONFIG_FILE} ];then
  #start daemon
  storjshare daemon start;
  echo "Using configuration file: ${STORJ_CONFIG_FILE}"
  #start farming node
  storjshare start -c ${STORJ_CONFIG_FILE}

  #Get the log directory
  storj_log_dir=$(grep loggerOutputFile ${STORJ_CONFIG_FILE}|cut -d':' -f2|cut -d',' -f1| tr -d '[:space:]')
  #remove quotes
  storj_log_dir="${storj_log_dir%\"}"
  storj_log_dir="${storj_log_dir#\"}"

  #Get nodeID from the logs name.
  node_id=$(ls ${storj_log_dir}/*.log|cut -d'_' -f1|uniq)
  node_id=$(basename ${node_id})

  #Print logs to stdout
  storjshare logs --nodeid ${node_id}
  #while true; do sleep 10000; done
else
  echo "ERROR: configuration file not found!" && exit 1
fi
