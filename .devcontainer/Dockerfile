# Base image
FROM ubuntu:latest

# Set noninteractive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        curl \
        git \
        unzip \
        build-essential \
        libssl-dev \
        pkg-config \
        xz-utils \
        ca-certificates \
        gnupg \
        lsb-release \
        jq \
        bash \
        tar \
        gzip \
        libc6 \
        libstdc++6
        
# Install Rust (needed for Noir and Foundry)
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:$PATH"

# Install Foundry
RUN curl -L https://foundry.paradigm.xyz | bash && \
    ~/.foundry/bin/foundryup
ENV PATH="/root/.foundry/bin:$PATH"

# Install Noir
RUN curl -L https://raw.githubusercontent.com/noir-lang/noirup/main/install | bash
ENV PATH="/root/.nargo/bin:$PATH"
RUN noirup -v 1.0.0-beta.9

# Install bb
RUN curl -L https://raw.githubusercontent.com/AztecProtocol/aztec-packages/refs/heads/master/barretenberg/bbup/install | bash
ENV PATH="/root/.bb:$PATH"
RUN bbup -v 1.2.1

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:$PATH"

# Default shell
CMD ["bash"]