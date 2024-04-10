FROM ubuntu:22.04 as builder

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    libpcre2-dev \
    libssl-dev \
    ninja-build \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Download and build lighttpd
COPY . src
RUN cmake -S src -B build
RUN cmake --build build

FROM ubuntu:22.04 as runner

RUN apt-get update && apt-get install -y \
    curl \
    libjansson4 \
    && rm -rf /var/lib/apt/lists/*

# Install lighttpd
COPY --from=builder build/build/lighttpd /usr/local/bin
COPY --from=builder build/build/mod_*.so /usr/local/lib

# Configure lighttpd
ADD lighttpd.conf /etc/lighttpd/lighttpd.conf
ADD conf.d /etc/lighttpd/conf.d

CMD lighttpd -D -f /etc/lighttpd/lighttpd.conf -m /usr/local/lib
