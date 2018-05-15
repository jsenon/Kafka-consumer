FROM golang:1.10-alpine

ARG LIBRDKAFKA_VERSION=v0.11.4

# Set the workdir to the full GOPATH of your project.
WORKDIR $GOPATH/src/github.com/jsenon/kafka-consumer

RUN apk add -U \
    bash \
    build-base \
    coreutils \
    curl \
    cyrus-sasl-dev \
    git \
    libevent \
    libressl2.6-libcrypto \
    libressl2.6-libssl \
    libsasl \
    lz4-dev \
    openssh \
    openssl \
    openssl-dev \
    python \
    yajl-dev \
    zlib-dev

RUN go get -u github.com/golang/dep/cmd/dep


# SASL support is disabled for now, due to issues when compiling a static
# binary. See: https://git.io/vAFFm
RUN cd $(mktemp -d) \
 && curl -sL "https://github.com/edenhill/librdkafka/archive/$LIBRDKAFKA_VERSION.tar.gz" | \
    tar -xz --strip-components=1 -f - \
 && ./configure --disable-sasl \
 && make -j \
 && make install

# Copy the entire project tree into the container, so we can build the binary.
COPY . .

# Install any defined project dependencies using `dep`.
RUN dep ensure -vendor-only

# Build a completely static binary, able to be used in a `scratch` container.
RUN go build -o /tmp/run -tags static_all

# Second build phase, copy the generated binary from the first build phase into
# a "scratch" image, and set the entrypoint to run the binary.
FROM golang:1.10-alpine

RUN apk add --no-cache curl wget
RUN addgroup -g 1000 -S www-user && \
    adduser -u 1000 -S www-user -G www-user

USER www-user
 
COPY --from=0 /tmp/run .
CMD ["./run"]
