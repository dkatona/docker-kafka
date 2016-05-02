Kafka 9.0.1 image.

### Maintainers

Don't forget to verify `KAFKA_VERSION` in the `Dockerfile`. Then ensure the build settings are correct on [Docker Hub](https://hub.docker.com/r/appcelerator/kafka/~/settings/automated-builds/).

To trigger a build, run:

    curl -X POST https://registry.hub.docker.com/u/appcelerator/kafka/trigger/cc9bca73-f7b3-48db-9c2d-754bf430201b/

Finally, verify that the image was built successfully on the [Build Details page](https://hub.docker.com/r/appcelerator/kafka/builds/).

### Tags

- `9.0.1`, `latest`

### Exposed ports

- `9092`

### Environment variables

  - BROKER_ID: kafka node number in the kafka cluster, default: 1
  - ZOOKEEPER_CONNECT: Zookeeper nodes connection string, default localhost:2181
  - KAFKA_IP: the public kafka node ip, default: localhost
  - CONSUL: for containerPilot, format ConsulIp:consulPort, if not exist then containerPolot if not used

### Example cluster

* 3 Kafka nodes `kid1`, `kid2`, `kid3`
* 3 zookeeper nodes: `zip1`, `zip2`, `zip3`
* consul ip:cip

```
docker run -d --name=kafka1 \
    -p 9092:9092 \
    -e "BROKER_ID=1 \
    -e "ZOOKEEPER_CONNECT=zip1:2181,zip2:2181,zip3:2181" \
    -e "KAFKA_IP=kip1" \
    -e "CONSUL=cip:8500" \
    appcelerator/kafka:latest

docker run -d --name=kafka2 \
    -p 9092:9092 \
    -e "BROKER_ID=2 \
    -e "ZOOKEEPER_CONNECT=zip1:2181,zip2:2181,zip3:2181" \
    -e "KAFKA_IP=kip2" \
    -e "CONSUL=cip:8500" \
    appcelerator/kafka:latest

docker run -d --name=kafka3 \
    -p 9092:9092 \
    -e "BROKER_ID=3 \
    -e "ZOOKEEPER_CONNECT=zip1:2181,zip2:2181,zip3:2181" \
    -e "KAFKA_IP=kip3" \
    -e "CONSUL=cip:8500" \
    appcelerator/kafka:latest
```
