# Define the Caddy version to use
ARG CADDY_VERSION=2

# Stage 1: Build Caddy with plugins
FROM caddy:${CADDY_VERSION}-builder-alpine AS builder

# Build Caddy with the required plugins
RUN xcaddy build \
    --with github.com/caddyserver/forwardproxy=github.com/klzgrad/forwardproxy@naive \
    --with github.com/mholt/caddy-webdav \
    --with github.com/mholt/caddy-ratelimit

# Stage 2: Create the final image
FROM caddy:${CADDY_VERSION}-alpine

# Copy the built Caddy binary from the builder stage
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# Expose necessary ports
EXPOSE 80
EXPOSE 443
EXPOSE 443/udp
EXPOSE 2019

# Set the working directory
WORKDIR /srv

# Define the default command
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
