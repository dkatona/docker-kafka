#!/bin/bash

set -euo pipefail

#TOPIC_LIST="amp-logs amp-service-start amp-service-stop amp-service-terminate amp-docker-events amp-service-events"

if [ -f /tmp/kafka-topics ]; then
    pidof java
else
    echo "Checking topic list..."
    list=$(bin/kafka-topics.sh --zookeeper $ZOOKEEPER_CONNECT --list)
    echo "Checking topic list : $list"
    for topicToCreate in $TOPIC_LIST
    do
        IFS=':' read -a topicConfig <<< "$topicToCreate"
        topic=${topicConfig[0]}
        partitions=${topicConfig[1]:-1}
        replication_factor=${topicConfig[2]:-1}
        if [[ $list =~ ^.*$topic ]]; then
            echo "$topic exists"
        else
            echo "Creating topic $topic with $partitions partitions and $replication_factor replication factor"
            bin/kafka-topics.sh --zookeeper $ZOOKEEPER_CONNECT --create --partitions=$partitions --replication-factor=$replication_factor --topic $topic
            echo "Creating topic $topic Done"
        fi
    done
    touch /tmp/kafka-topics
fi

