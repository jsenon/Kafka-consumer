#-----------------------------------------------------------------------------
# Global Variables
#-----------------------------------------------------------------------------
SHELL=bash

APP_VERSION := latest

#-----------------------------------------------------------------------------
# PRE REQUISITE
#-----------------------------------------------------------------------------

.PHONY: prerequisite
prerequisite:
	git clone https://github.com/edenhill/librdkafka.git
	cd librdkafka && ./configure && make && sudo make install


#-----------------------------------------------------------------------------
# BUILD
#-----------------------------------------------------------------------------

.PHONY: default build test publish build_local lint
default: prerequisite depend test lint build 

depend:
	go get -u github.com/golang/dep
	dep ensure
test:
	go test -v ./...
build:
	go build 
lint:
	go get -u github.com/alecthomas/gometalinter
	gometalinter --install
	gometalinter ./... --exclude=vendor --deadline=60s


#-----------------------------------------------------------------------------
# CLEAN
#-----------------------------------------------------------------------------

.PHONY: clean 

clean:
	rm -rf kafka-consumer
	if [ -d librdkafka ]; then \
		cd librdkafka && make clean && make distclean ; \
	fi
	rm -rf librdkafka
