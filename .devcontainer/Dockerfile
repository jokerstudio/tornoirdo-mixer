FROM oven/bun:1.2.2
SHELL ["/bin/bash", "-c"]
RUN apt update && apt install -y make jq curl bash git tar gzip libc++-dev
RUN corepack enable && corepack install --global yarn@1.22.22
RUN curl -L https://raw.githubusercontent.com/noir-lang/noirup/main/install | bash
ENV PATH="/root/.nargo/bin:$PATH"
RUN noirup -v 1.0.0-beta.1
RUN curl -L https://raw.githubusercontent.com/AztecProtocol/aztec-packages/refs/heads/master/barretenberg/bbup/install | bash
ENV PATH="/root/.bb:$PATH"
RUN bbup -v 0.75.0
RUN curl -L https://foundry.paradigm.xyz | bash
ENV PATH="/root/.foundry/bin:$PATH"
RUN foundryup
ENTRYPOINT ["nargo"]