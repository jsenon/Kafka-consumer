[![CircleCI](https://circleci.com/gh/jsenon/kafka-consumer.svg?style=svg)](https://circleci.com/gh/jsenon/kafka-consumer)
[![Go Report Card](https://goreportcard.com/badge/github.com/jsenon/kafka-consumer)](https://goreportcard.com/report/github.com/jsenon/kafka-consumer)

# Kafka Consumer
 
This is a Simple kafka consumer

### Func

Use container in order to debug kafka 

## Build

Build locally
```
make 
```

## Run Container

Run Container
```
docker run -d -e MY_KAFKABOOTSTRAP="123.123.123.123:9092" -e MY_TOPIC="kikoo"  -e MY_GROUPID="consumergroup1"  jsenon/kafka-consumer:latest
```

## Run on K8S Cluster

Deploy POD
```
kubectl apply -f k8s/deployment.yml
```

## Env

- MY_KAFKABOOTSTRAP: Define kafka bootstrap server ie.127.0.0.1
- MY_TOPIC: Define topic to check ie.mytest
- MY_GROUPID: Define Consumer group ie.mygroup

## Todo

[ ] Change Ubuntu with docker image that support gcc and c++
