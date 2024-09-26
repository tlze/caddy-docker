FROM alpine AS builder
WORKDIR /app

RUN apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community --no-cache git go
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest && \
        ~/go/bin/xcaddy build \
        --with github.com/caddyserver/forwardproxy=github.com/klzgrad/forwardproxy@naive \
        --with github.com/mholt/caddy-webdav \
        --with github.com/caddy-dns/cloudflare \
        --with github.com/caddy-dns/alidns \
        --with github.com/mholt/caddy-ratelimit

FROM alpine

COPY --from=builder /app/caddy /usr/bin/caddy

EXPOSE 80
EXPOSE 443
EXPOSE 443/udp
EXPOSE 2019

WORKDIR /srv

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
