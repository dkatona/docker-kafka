#!/bin/bash

#set -euo pipefail

#display env. variables
echo ---------------------------------------------------------------------------
echo "ZOOKEEPER_CONNECT: "$ZOOKEEPER_CONNECT
echo "CONSUL: "$CONSUL
echo "DEPENDENCIES: "$DEPENDENCIES
if [ -z "$BROKER_ID" ]; then
  #Get Kafka BrokerId from Consul
  export BID=$(curl -s --max-time 10 http://$CONSUL/v1/kv/kafkaId?raw)
  echo "Current Kafka broker id in Consul: "$BID
  if [ -z "$BID" ]; then
    BID=1
  else
    BID=$(($BID+1))
    if [[ "$BID" = "1000" ]]; then
      BID=1
    fi
  fi
  export BROKER_ID=$BID
  curl -X PUT -s --max-time 10 --data $BID http://$CONSUL/v1/kv/kafkaId
fi
if [ -z "$BROKER_ID" ]; then
  export BROKER_ID=990
fi
echo "BROKER_ID: "$BROKER_ID
KAFKA_IP=$(ip route get 8.8.8.8 | awk '{print $NF; exit}')
echo "KAFKA_IP: "$KAFKA_IP

#update config regarding env. variables
sed -i "s/reserved.broker.max.id = 1000/reserved.broker.max.id = 100000/g" /opt/kafka/config/server.properties
sed -i "s/broker.id=0/broker.id=$BROKER_ID/g" /opt/kafka/config/server.properties
sed -i "s/zookeeper.connect=localhost:2181/zookeeper.connect=$ZOOKEEPER_CONNECT/g" /opt/kafka/config/server.properties
sed -i "s/#advertised.host.name=<hostname routable by clients>/advertised.host.name=$KAFKA_IP/g" /opt/kafka/config/server.properties
#lauch kafka
if [ -z "$CONSUL" ]; then
  exec /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
else
  echo ---------------------------------------------------------------------------
  echo containerPilot conffile
  cat /etc/containerpilot.json
  echo ---------------------------------------------------------------------------
  while true
  do
    ready=0
    while [ "$ready" != "1" ]
      do
      ready=1
      for service in $DEPENDENCIES
      do
        status=$(curl --max-time 3 -s http://$CONSUL/v1/health/checks/$service)
        if [[ $status =~ ^.*\"Status\":\"passing\" ]]; then
          echo $service" is ready"
        else
          echo "status: "$status
          echo http://$CONSUL/v1/health/checks/$service
          echo $service" is not yet ready"
          ready=0
        fi
      done
      if [ "$ready" == "0" ]; then
        echo "Waiting for dependencies"
        sleep 10
      fi
    done
    sleep 3
    echo "All dependencies are ready"
    /bin/containerpilot /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
  done
fi
