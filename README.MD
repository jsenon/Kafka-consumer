[![CircleCI](https://circleci.com/gh/jsenon/kafka-consumer.svg?style=svg)](https://circleci.com/gh/jsenon/kafka-consumer)
[![Go Report Card](https://goreportcard.com/badge/github.com/jsenon/kafka-consumer)](https://goreportcard.com/report/github.com/jsenon/kafka-consumer)

# Kafka Consumer
 
This is a Simple kafka consumer

### Func

DRAFT

## Build

Build docker container
```
make build
```

### Launch Container


### Usage



### Env


### TIPS

If you receive `cannot execute binary file: Exec format error`

Compile with  `CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build demoserver.go`

And build `docker build -t jsenon/kafka-consumer:vx.x .`
