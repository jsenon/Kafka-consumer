FROM ubuntu:latest

RUN apt-get update && apt-get install -y git make gcc build-essential

RUN git clone https://github.com/edenhill/librdkafka.git && cd librdkafka && ./configure  --prefix /usr && make && make install

ENV MY_KAFKABOOTSTRAP=127.0.0.1

ENV MY_TOPIC=mytest
ENV MY_GROUPID=mygroup

ADD kafka-consumer /

CMD ["./kafka-consumer"]


# FROM alpine:latest
# RUN apk add --no-cache bash curl wget
# RUN addgroup -g 1000 -S www-user && \
#     adduser -u 1000 -S www-user -G www-user
# ENV MY_KAFKABOOTSTRAP=127.0.0.1
# ENV MY_TOPIC=mytest
# ENV MY_GROUPID=mygroup
# ADD kafka-consumer /
# USER www-user
# CMD ["./kafka-consumer"]



