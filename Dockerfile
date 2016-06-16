FROM anapsix/alpine-java:8
MAINTAINER Francois Reignat <freignat@axway.com>
# Add ContainerPilot
RUN apk update && apk add sed bash curl gpgme
ENV CONTAINERPILOT=2.1.0
RUN curl -Lo /tmp/cb.tar.gz https://github.com/joyent/containerpilot/releases/download/$CONTAINERPILOT/containerpilot-$CONTAINERPILOT.tar.gz \
&& tar -xz -f /tmp/cb.tar.gz \
&& mv ./containerpilot /bin/
COPY containerpilot.json /etc/containerpilot.json

ENV CP_LOG_LEVEL=ERROR
ENV CP_TTL=20
ENV CP_POLL=5
ENV CP_POLL_DEP=5
ENV CP_RESTART_DELAY=10
ENV CONTAINERPILOT=file:///etc/containerpilot.json

ENV KAFKA_VERSION=0.10.0.0

LABEL name="kafka" version=$KAFKA_VERSION

RUN wget "http://mirror.cc.columbia.edu/pub/software/apache/kafka/$KAFKA_VERSION/kafka_2.11-$KAFKA_VERSION.tgz" -O /tmp/kafka.tgz \
&& mkdir -p /opt \
&& tar -xvzf /tmp/kafka.tgz -C /opt \
&& mv /opt/kafka_2.11-$KAFKA_VERSION /opt/kafka

WORKDIR /opt/kafka

COPY ./start.sh /opt/kafka/bin/start.sh
COPY ./start.sh /opt/kafka/bin/stop.sh
COPY ./check.sh /opt/kafka/bin/check.sh
COPY ./server.properties /opt/kafka/config/server.properties
COPY ./log4j.properties /opt/kafka/config/log4j.properties

ENV ZOOKEEPER_CONNECT localhost:2181
ENV KAFKA_IP=localhost


ENV TOPICS_CREATED=0
ENV DEPENDENCIES="zookeeper amp-log-agent"
ENV TOPIC_LIST="amp-logs amp-service-start amp-service-stop amp-service-terminate amp-docker-events amp-service-events"


EXPOSE 9092

CMD ["/opt/kafka/bin/start.sh"]
