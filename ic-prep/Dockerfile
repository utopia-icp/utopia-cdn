FROM --platform=linux/amd64 ubuntu:24.04 AS build

RUN apt update && apt install -y build-essential curl

# Install Rust and Cargo

ENV RUSTUP_HOME=/opt/rustup
ENV CARGO_HOME=/opt/cargo
ENV RUST_VERSION=1.77.1

ENV PATH=/opt/cargo/bin:${PATH}
RUN curl --fail https://sh.rustup.rs -sSf \
    | sh -s -- -y --default-toolchain ${RUST_VERSION}-x86_64-unknown-linux-gnu --no-modify-path
RUN rustup default ${RUST_VERSION}-x86_64-unknown-linux-gnu

# Rust tools

ADD ./node_config_generator /workspace/node_config_generator
ADD ./registry_init_args_generator /workspace/registry_init_args_generator

RUN cd /workspace/node_config_generator && cargo build --release
RUN cd /workspace/registry_init_args_generator && cargo build --release

# Final image

FROM --platform=linux/amd64 ubuntu:24.04

RUN apt update && apt install -y ca-certificates curl

WORKDIR /workspace

# Replica version

ARG IC_COMMIT

RUN echo ${IC_COMMIT} > /workspace/version.txt

# Binaries

ARG DFINITY_ARTIFACTS_URL='https://dfinity-download-public.s3.eu-central-1.amazonaws.com'

ADD ${DFINITY_ARTIFACTS_URL}/ic/${IC_COMMIT}/release/ic-prep.gz .
RUN zcat ic-prep.gz > /usr/local/bin/ic-prep && chmod +x /usr/local/bin/ic-prep && rm ic-prep.gz
COPY --from=build /workspace/node_config_generator/target/release/config /usr/local/bin/config
COPY --from=build /workspace/registry_init_args_generator/target/release/registry-init-arg /usr/local/bin/registry-init-arg

# Scripts

COPY ./prep.sh /usr/local/bin/prep.sh

ENTRYPOINT [ "/usr/local/bin/prep.sh" ]
