#!/bin/bash

set -euo pipefail

fullList="amp-logs amp-service-start amp-service-stop amp-service-terminate amp-docker-events amp-service-events"

list=$(bin/kafka-topics.sh --zookeeper $ZOOKEEPER_CONNECT --list)
for topic in $fullList
do
	if [[ $list =~ ^.*$topic ]]; then
		echo $topic" exists"
	else
		bin/kafka-topics.sh --zookeeper $ZOOKEEPER_CONNECT --create --partitions=1 --replication-factor=1 --topic $topic
	fi
done