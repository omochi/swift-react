FROM ubuntu:22.04

ENV SWIFT_CHANNEL development
ENV SWIFT_VERSION swift-DEVELOPMENT-SNAPSHOT-2024-05-01-a
ENV WASM_VERSION swift-wasm-DEVELOPMENT-SNAPSHOT-2024-05-02-a

EXPOSE 8080

RUN apt-get -q update
RUN DEBIAN_FRONTEND=noninteractive TZ=Asia/Tokyo \
    apt-get install -y \
    binutils \
    git \
    gnupg2 \
    libc6-dev \
    libcurl4-openssl-dev \
    libedit2 \
    libgcc-9-dev \
    libpython3.8 \
    libsqlite3-0 \
    libstdc++-9-dev \
    libxml2-dev \
    libz3-dev \
    pkg-config \
    tzdata \
    unzip \
    zlib1g-dev \
    curl

WORKDIR /setup

RUN curl -fLO https://download.swift.org/${SWIFT_CHANNEL}/ubuntu2204-aarch64/${SWIFT_VERSION}/${SWIFT_VERSION}-ubuntu22.04-aarch64.tar.gz
RUN tar -xvf ${SWIFT_VERSION}-ubuntu22.04-aarch64.tar.gz --strip-components=2 -C /usr

RUN swift sdk install https://github.com/swiftwasm/swift/releases/download/${WASM_VERSION}/${WASM_VERSION}-wasm32-unknown-wasi.artifactbundle.zip

# RUN git clone https://github.com/swiftwasm/carton
# RUN cd carton && swift build -c release
# RUN cd carton/.build/release && cp CartonFrontend carton /usr/local/bin

ENV WEBDRIVER_REMOTE_URL http://host.docker.internal:7055