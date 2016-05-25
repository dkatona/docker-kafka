FROM anapsix/alpine-java:8
MAINTAINER Francois Reignat <freignat@axway.com>

ENV KAFKA_VERSION=0.9.0.1

RUN apk update && apk add sed bash curl \
&& wget "http://mirror.cc.columbia.edu/pub/software/apache/kafka/$KAFKA_VERSION/kafka_2.11-$KAFKA_VERSION.tgz" -O /tmp/kafka.tgz \
&& mkdir -p /opt \
&& tar -xvzf /tmp/kafka.tgz -C /opt \
&& mv /opt/kafka_2.11-$KAFKA_VERSION /opt/kafka \
&& echo "delete.topic.enable = true" >> /opt/kafka/config/server.properties

WORKDIR /opt/kafka

COPY ./start.sh /opt/kafka/bin/start.sh
COPY ./start.sh /opt/kafka/bin/stop.sh
COPY ./check.sh /opt/kafka/bin/check.sh
#COPY ./server.properties /opt/kafka/config/server.properties

ENV ZOOKEEPER_CONNECT localhost:2181
ENV KAFKA_IP=localhost

# Add ContainerPilot
ENV CONTAINERPILOT=2.1.0
RUN curl -Lo /tmp/cb.tar.gz https://github.com/joyent/containerpilot/releases/download/$CONTAINERPILOT/containerpilot-$CONTAINERPILOT.tar.gz \
&& tar -xz -f /tmp/cb.tar.gz \
&& mv ./containerpilot /bin/
COPY containerpilot.json /etc/containerpilot.json

#ENV CONSUL=consul:8500
#ENV ZOOKEEPER_CONNECT=zookeeper:2181
ENV TOPICS_CREATED=0
ENV CP_LOG_LEVEL=ERROR
ENV CP_POLL=5
ENV CP_TTL=20
ENV CONTAINERPILOT=file:///etc/containerpilot.json
ENV DEPENDENCIES="zookeeper amp-log-agent"
ENV TOPIC_LIST="amp-logs amp-service-start amp-service-stop amp-service-terminate amp-docker-events amp-service-events"


EXPOSE 9092

CMD ["/opt/kafka/bin/start.sh"]
