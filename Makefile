DOCKER = podman

all: clean build run

clean:
	-$(DOCKER) stop ts3:dev
	-$(DOCKER) rm -f ts3:dev
	-$(DOCKER) rmi -f ts3:dev
	-$(DOCKER) unshare rm -rf $(CURDIR)/data

build:
	$(DOCKER) build               \
	  --tag "ts3:dev"             \
	  .

run:
	mkdir -p data
	$(DOCKER) run                 \
	  --name=ts3server            \
	  --interactive               \
	  --tty                       \
	  --rm                        \
	  -e PUID=666                 \
	  -e PGID=777                 \
	  -e TS3SERVER_LICENSE=accept \
	  -p 9987:9987/udp            \
	  -p 30033:30033              \
	  -p 41144:41144              \
	  -p 127.0.0.1:10011:10011    \
	  -p 127.0.0.1:10022:10022    \
	  -p 127.0.0.1:10080:10080    \
	  -p 127.0.0.1:10443:10443    \
	  -v ${PWD}/data:/data        \
	  "ts3:dev"

.PHONY: all build run
