FROM anapsix/alpine-java:8
MAINTAINER Francois Reignat <freignat@axway.com>

ENV KAFKA_VERSION=2.11-0.9.0.1

# Currently enabling auto create topics (will set to false once all topics are identified)
#
RUN wget "http://mirror.cc.columbia.edu/pub/software/apache/kafka/0.9.0.1/kafka_$KAFKA_VERSION.tgz" -O /tmp/kafka.tgz \
&& mkdir -p /opt \
&& tar -xvzf /tmp/kafka.tgz -C /opt \
&& mv /opt/kafka_$KAFKA_VERSION /opt/kafka \
&& echo "delete.topic.enable = true" >> /opt/kafka/config/server.properties \
&& echo "auto.create.topics.enable = true" >> /opt/kafka/config/server.properties \
&& apk add -t sed

WORKDIR /opt/kafka

COPY ./start.sh ./start.sh

ENV BROKER_ID 1
ENV ZOOKEEPER_CONNECT localhost:2181
ENV KAFKA_IP=localhost

EXPOSE 9092

CMD ["sh", "-c", "./start.sh"]
