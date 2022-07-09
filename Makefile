DOCKER = docker

all: clean build run

clean:
	-$(DOCKER) stop ts3:dev
	-$(DOCKER) rm -f ts3:dev
	-$(DOCKER) rmi -f ts3:dev

build:
	$(DOCKER) build               \
	  --tag "ts3:dev"             \
	  .

run:
	mkdir -p data
	$(DOCKER) run                 \
	  --name=ts3dev               \
	  --interactive               \
	  --tty                       \
	  --rm                        \
	  -e TS3SERVER_LICENSE=accept \
	  -p 9987:9987/udp            \
	  -p 30033:30033              \
	  -p 127.0.0.1:10080:10080    \
	  -p 127.0.0.1:10443:10443    \
	  -v ${PWD}/data:/data        \
	  "ts3:dev"

.PHONY: all clean build run
