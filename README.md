# docker-stunnel

Simplistic `stunnel` image for securing containerized workloads.

## Rotating certificates

When using a service that manages the rotation of mounted certificates,
`stunnel` will need to be `hup`'d to re-read the files. Until kubernetes [adds
native support for signaling](https://github.com/kubernetes/kubernetes/issues/24957),
the entrypoint includes a workaround based on [inotify](https://en.wikipedia.org/wiki/Inotify).

To monitor certificates for changes, set environment variables accordingly:

```yaml
env:
  - name: "INOTIFYWAIT_ENABLED"
    value: "1"
  - name: "INOTIFYWAIT_FILES"
    value: >-
      /etc/stunnel/tls.d/service1/tls.crt
      /etc/stunnel/tls.d/service2/tls.crt
```
