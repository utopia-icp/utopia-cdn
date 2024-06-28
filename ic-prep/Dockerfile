FROM --platform=linux/amd64 ubuntu:24.04

RUN apt update && apt install -y build-essential ca-certificates curl

ENV RUSTUP_HOME=/opt/rustup
ENV CARGO_HOME=/opt/cargo
ENV RUST_VERSION=1.77.1

# Install Rust and Cargo

ENV PATH=/opt/cargo/bin:${PATH}
RUN curl --fail https://sh.rustup.rs -sSf \
    | sh -s -- -y --default-toolchain ${RUST_VERSION}-x86_64-unknown-linux-gnu --no-modify-path
RUN rustup default ${RUST_VERSION}-x86_64-unknown-linux-gnu

# Rust tools

ADD ./node_config_generator /workspace/node_config_generator
ADD ./registry_init_args_generator /workspace/registry_init_args_generator

RUN cd /workspace/node_config_generator && cargo build --release
RUN cd /workspace/registry_init_args_generator && cargo build --release

# Replica version

ARG IC_COMMIT='ec35ebd252d4ffb151d2cfceba3a86c4fb87c6d6'

RUN echo ${IC_COMMIT} > /workspace/version.txt

# Binaries

ARG DFINITY_ARTIFACTS_URL='https://dfinity-download-public.s3.eu-central-1.amazonaws.com'

ADD ${DFINITY_ARTIFACTS_URL}/ic/${IC_COMMIT}/release/ic-prep.gz .
RUN zcat ic-prep.gz > /usr/bin/ic-prep && chmod +x /usr/bin/ic-prep && rm ic-prep.gz

# Scripts

COPY ./prep.sh /usr/bin/prep.sh

ENTRYPOINT [ "/usr/bin/prep.sh" ]
