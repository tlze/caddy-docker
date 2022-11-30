FROM alpine AS builder
WORKDIR /app

RUN apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community --no-cache git go
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest && \
        ~/go/bin/xcaddy build --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive \
        --with  github.com/mholt/caddy-webdav

FROM alpine

COPY --from=builder /app/caddy /usr/bin/caddy

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

EXPOSE 80
EXPOSE 443
EXPOSE 443/udp
EXPOSE 2019

WORKDIR /srv

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
