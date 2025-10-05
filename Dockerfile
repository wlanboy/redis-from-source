# Build Stage
FROM debian:trixie-slim AS builder

ARG REDIS_VERSION 

# Build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    curl \
    dpkg-dev \
    pkg-config \
    gcc \
    g++ \
    libc6-dev \
    libssl-dev \
    make \
    cmake \
    git \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    unzip \
    rsync \
    clang \
    automake \
    autoconf \
    libtool 

# Download Redis
RUN curl -fsSL https://github.com/redis/redis/archive/refs/tags/${REDIS_VERSION}.tar.gz | tar xz
# Build Redis server without modules which need rust
RUN cd redis-${REDIS_VERSION} && make redis-server BUILD_STATIC=yes BUILD_WITH_SYSTEMD=no BUILD_WITH_MODULES=no BUILD_TLS=no DISABLE_WERRORS=yes -j$(nproc) LDFLAGS="-static"
# Build Redis client 
RUN cd redis-${REDIS_VERSION} && make redis-cli BUILD_STATIC=yes BUILD_TLS=no DISABLE_WERRORS=yes -j$(nproc) LDFLAGS="-static"

# Final Stage
FROM gcr.io/distroless/cc

ARG REDIS_VERSION 

# Redis binaries
COPY --from=builder /redis-${REDIS_VERSION}/src/redis-server /usr/local/bin/redis-server
COPY --from=builder /redis-${REDIS_VERSION}/src/redis-cli /usr/local/bin/redis-cli

# Volume for persistence
VOLUME ["/data"]

USER nonroot
EXPOSE 6379 9121

ENTRYPOINT ["/usr/local/bin/redis-server"]
CMD ["/etc/redis.conf"]
