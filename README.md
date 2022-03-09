## ts3-docker

[docker hub](https://hub.docker.com/r/n0thub/ts3)

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
API_KEY="FooBar2IHhPcvwI3tD7G9sFrPOGn5QdOrI1nWsH"
curl -H "x-api-key: $API_KEY" 127.0.0.1:10080/serverinfo | jq
```
