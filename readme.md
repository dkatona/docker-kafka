Kafka 9.0.1 image.

### Maintainers

To trigger a build, run:

    curl -X POST https://registry.hub.docker.com/u/appcelerator/kafka/trigger/cc9bca73-f7b3-48db-9c2d-754bf430201b/

Finally, verify that the image was built successfully on the [Build Details page](https://hub.docker.com/r/appcelerator/kafka/builds/).

### Tags

- `9.0.1`, `latest`

### Exposed ports

- `9092`


### Env. variables

  - ZOOKEEPER_CONNECT: Zookeeper nodes connection string, default localhost:2181
  - BROKER_IP: if not defined (in docker-compose for instance), use CONSUL to get the right id in Consul kv.
  - CONSUL: for containerPilot, format ConsulIp:consulPort, if not exist then containerPolot if not used

### sample with Docker compose, 3 zookeeper nodes: zookeeper1, zookeeper2 and consul


    $ZOOKZEEPER_CONNECT="zookeper1:2181,zookeeper2:2181,zookeeper3:2181"
    $CONSUL=consul:8500


    services:
      kakfa:
        image: appcelerator/kafka:latest
        ports:
         - "9092:9092"
        environment:
         - ZOOKEEPER_CONNECT=$ZOOKEEPER_CONNECT
         - CONSUL=$CONSUL


### sample with 3 Kafka nodes and 3 zookeeper nodes: zookeeper1, zookeeper2, zookeeper3, without containerPilot


    $ZOOKZEEPER_CONNECT="zookeper1:2181,zookeeper2:2181,zookeeper3:2181"


    docker run -d --name=kafka1 \
      -p 9092:9092 \
      -e "ZOOKEEPER_CONNECT=$ZOOKEEPER_CONNECT" \
      -e "BROKER_ID=1" \
      appcelerator/kafka:latest


    docker run -d --name=kafka2 \
      -p 9092:9092 \
      -e "ZOOKEEPER_CONNECT=$ZOOKEEPER_CONNECT" \
      -e "BROKER_ID=2" \
      appcelerator/kafka:latest


    docker run -d --name=kafka3 \
      -p 9092:9092 \
      -e "ZOOKEEPER_CONNECT=$ZOOKEEPER_CONNECT" \
      -e "BROKER_ID=3" \
      appcelerator/kafka:latest
