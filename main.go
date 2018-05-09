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
			zap.Int("statusCode", 500),
			zap.Duration("backoff", time.Second),
			zap.Error(err),
		)
	}

	c, err := kafka.NewConsumer(&kafka.ConfigMap{
		"bootstrap.servers": mykafkabootstrap,
		"group.id":          mygroupid,
		"auto.offset.reset": "earliest",
	})

	if err != nil {
		logger.Error("Failed to create Kafka logger",
			zap.String("status", "ERROR"),
			zap.Int("statusCode", 500),
			zap.Duration("backoff", time.Second),
			zap.Error(err),
		)
	}

	c.SubscribeTopics([]string{mytopic, "^aRegex.*[Tt]opic"}, nil)

	for {
		msg, err := c.ReadMessage(-1)
		if err == nil {
			fmt.Printf("Message on %s: %s\n", msg.TopicPartition, string(msg.Value))
		} else {
			fmt.Printf("Consumer error: %v (%v)\n", err, msg)
			break
		}
	}

	c.Close()
}
