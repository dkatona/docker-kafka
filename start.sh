#display env. variables
echo "KAFKA_IP: "$KAFKA_IP
echo "BROKER_ID: "$BROKER_ID
echo "ZOOKEEPER_CONNECT: "$ZOOKEEPER_CONNECT
#update config regarding env. variables
sed -i "s/broker.id=0/broker.id=$BROKER_ID/g" /opt/kafka/config/server.properties
sed -i "s/zookeeper.connect=localhost:2181/zookeeper.connect=$ZOOKEEPER_CONNECT/g" /opt/kafka/config/server.properties
sed -i "s/#advertised.host.name=<hostname routable by clients>/advertised.host.name=$KAFKA_IP/g" /opt/kafka/config/server.properties
#lauch kafka
/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
