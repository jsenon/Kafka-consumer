FROM alpine:latest

RUN apk add --no-cache bash curl wget alpine-sdk
RUN git clone https://github.com/edenhill/librdkafka.git && cd librdkafka && ./configure  --prefix /usr && make && make install

RUN addgroup -g 1000 -S www-user && \
    adduser -u 1000 -S www-user -G www-user

ENV MY_KAFKABOOTSTRAP=127.0.0.1
ENV MY_TOPIC=mytest
ENV MY_GROUPID=mygroup

ADD kafka-consumer /
USER www-user

CMD ["./kafka-consumer"]