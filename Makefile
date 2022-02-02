REQUIRED_BINS := podman docker-compose
$(foreach bin,$(REQUIRED_BINS), \
    $(if $(shell command -v $(bin) 2> /dev/null),$(),$(error please install missing build requirement: `$(bin)`)))

.PHONY: all
all: build run

.PHONY: build
build:
	podman build                  \
	  --tag "ts3:latest"          \
	  --tag "ts3:3.13.6"          \
	  .

.PHONY: run
run:
	mkdir -p data
	podman run                    \
	  --name=ts3server            \
	  --interactive               \
	  --tty                       \
	  --rm                        \
	  -e TS3SERVER_LICENSE=accept \
	  -p 9987:9987/udp            \
	  -p 30033:30033              \
	  -p 41144:41144              \
	  -p 127.0.0.1:10011:10011    \
	  -p 127.0.0.1:10022:10022    \
	  -p 127.0.0.1:10080:10080    \
	  -p 127.0.0.1:10443:10443    \
	  -v ${PWD}/data:/data        \
	  "ts3:latest"
