## ts3-docker

[docker hub](https://hub.docker.com/r/n0thub/ts3)

---

### run example

```shell
docker run                    \
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
  "n0thub/ts3"
```

---

### server ports

- 9987/udp - Voice
- 10011/tcp - ServerQuery (raw)
- 10022/tcp - ServerQuery (ssh)
- 10080/tcp - WebQuery (http)
- 10443/tcp - WebQuery (https)
- 30033/tcp - Filetransfer
- 41144/tcp - TSDNS

---

### webquery curl example

```bash
curl -H "x-api-key: $api_key" 127.0.0.1:10080/serverinfo | jq
```
