FROM anapsix/alpine-java:8
MAINTAINER Francois Reignat <freignat@axway.com>

ENV KAFKA_VERSION=2.11-0.9.0.1

RUN apk update && apk add sed bash curl \
&& wget "http://mirror.cc.columbia.edu/pub/software/apache/kafka/0.9.0.1/kafka_$KAFKA_VERSION.tgz" -O /tmp/kafka.tgz \
&& mkdir -p /opt \
&& tar -xvzf /tmp/kafka.tgz -C /opt \
&& mv /opt/kafka_$KAFKA_VERSION /opt/kafka \
&& echo "delete.topic.enable = true" >> /opt/kafka/config/server.properties

WORKDIR /opt/kafka

COPY ./start.sh ./start.sh

ENV BROKER_ID 1
ENV ZOOKEEPER_CONNECT localhost:2181
ENV KAFKA_IP=localhost

# Add ContainerPilot
RUN curl -Lo /tmp/cb.tar.gz https://github.com/joyent/containerpilot/releases/download/2.1.0/containerpilot-2.1.0.tar.gz \
&& tar -xz -f /tmp/cb.tar.gz \
&& mv ./containerpilot /bin/
COPY containerpilot.json /etc/containerpilot.json

ENV CONTAINERPILOT=file:///etc/containerpilot.json

EXPOSE 9092

CMD ["sh", "-c", "./start.sh"]
