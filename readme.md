Kafka 9.0.1 image.

### Tags

- `9.0.1`, `latest`

### Exposed ports

- `9092`


### Env. variables

	- BROKER_ID: kafka node number in the kafka cluster, default: 1
	- ZOOKEEPER_CONNECT: Zookeeper nodes connection string, default localhost:2181
	- KAFKA_IP: the public kafka node ip, default: localhost

### sample with 3 Kafka nodes kid1, kid2, kid3, and 2 zookeeper nodes: zip1, zip2


	docker run -d --name=kafka1 \
	    -p 9092:9092 \
	    -e "BROKER_ID=1 \
	    -e "ZOOKEEPER_CONNECT=zip1:2181,zip2:2181" \
	    -e "KAFKA_IP=kip1" \
	    --net="host" \
	    appcelerator/kafka:latest

	docker run -d --name=kafka2 \
		-p 9092:9092 \
		-e "BROKER_ID=2 \
		-e "ZOOKEEPER_CONNECT=zip1:2181,zip2:2181" \
		-e "KAFKA_IP=kip2" \
		--net="host" \
		appcelerator/kafka:latest

	docker run -d --name=kafka3 \
		-p 9092:9092 \
		-e "BROKER_ID=3 \
		-e "ZOOKEEPER_CONNECT=zip1:2181,zip2:2181" \
		-e "KAFKA_IP=kip3" \
		--net="host" \
		appcelerator/kafka:latest
  
