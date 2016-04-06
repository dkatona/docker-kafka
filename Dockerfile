#Kafka with Zooker in cluster

FROM ubuntu:14.04.4

RUN apt-get update
RUN apt-get install -y default-jre
RUN apt-get install -y wget 

RUN useradd kafka -m

#-----to allow debug inside the container to be removed
RUN adduser kafka sudo
COPY ./pwd ./pwd
RUN passwd kafka <./pwd
RUN rm ./pwd
#-----

USER kafka

ENV BROKER_ID 1
ENV ZOOKEEPER_CONNECT localhost:2181
ENV KAFKA_IP=localhost

RUN mkdir -p /home/kafka/Downloads
RUN wget "http://mirror.cc.columbia.edu/pub/software/apache/kafka/0.9.0.1/kafka_2.11-0.9.0.1.tgz" -O /home/kafka/Downloads/kafka.tgz
RUN mkdir -p /home/kafka/kafka 
WORKDIR /home/kafka/kafka
RUN tar -xvzf ~/Downloads/kafka.tgz --strip 1
RUN echo "delete.topic.enable = true" >> /home/kafka/kafka/config/server.properties
COPY ./start.sh ./start.sh

EXPOSE 9092
CMD ["sh", "-c", "./start.sh"]
