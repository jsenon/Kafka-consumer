package main

import (
	"fmt"
	"os"
	"time"

	"github.com/confluentinc/confluent-kafka-go/kafka"
	"go.uber.org/zap"
)

func main() {

	mykafkabootstrap := os.Getenv("MY_KAFKABOOTSTRAP")
	mytopic := os.Getenv("MY_TOPIC")
	mygroupid := os.Getenv("MY_GROUPID")

	logger, err := zap.NewProduction()
	if err != nil {
		logger.Error("Failed to create zap logger",
			zap.String("status", "ERROR"),
			zap.Duration("backoff", time.Second),
			zap.Error(err),
		)
		return
	}

	c, err := kafka.NewConsumer(&kafka.ConfigMap{
		"bootstrap.servers": mykafkabootstrap,
		"group.id":          mygroupid,
		"auto.offset.reset": "earliest",
	})

	if err != nil {
		logger.Error("Failed to create Kafka logger",
			zap.String("status", "ERROR"),
			zap.Duration("backoff", time.Second),
			zap.Error(err),
		)
		return
	}

	err = c.SubscribeTopics([]string{mytopic, "^aRegex.*[Tt]opic"}, nil)
	if err != nil {
		logger.Error("Failed to Subscribe Kafka topics",
			zap.String("status", "ERROR"),
			zap.Duration("backoff", time.Second),
			zap.Error(err),
		)
		return
	}

	for {
		msg, errread := c.ReadMessage(-1)
		if errread == nil {
			fmt.Printf("Message on %s: %s\n", msg.TopicPartition, string(msg.Value))
		} else {
			fmt.Printf("Consumer error: %v (%v)\n", errread, msg)
			break
		}
	}

	err = c.Close()
	if err != nil {
		logger.Error("Failed to close Kafka",
			zap.String("status", "ERROR"),
			zap.Duration("backoff", time.Second),
			zap.Error(err),
		)
		return
	}
}
