FROM --platform=linux/amd64 ubuntu:24.04

RUN \
    apt update && apt install -y \
        libunwind-dev

# binaries

ARG DFINITY_ARTIFACTS_URL='https://dfinity-download-public.s3.eu-central-1.amazonaws.com'

ARG REPLICA_REF='ec35ebd252d4ffb151d2cfceba3a86c4fb87c6d6'
ADD ${DFINITY_ARTIFACTS_URL}/ic/${REPLICA_REF}/release/replica.gz .
RUN zcat replica.gz > /usr/bin/replica && chmod +x /usr/bin/replica && rm replica.gz

ARG CANISTER_SANDBOX_REF='ec35ebd252d4ffb151d2cfceba3a86c4fb87c6d6'
ADD ${DFINITY_ARTIFACTS_URL}/ic/${CANISTER_SANDBOX_REF}/release/canister_sandbox.gz .
RUN zcat canister_sandbox.gz > /usr/bin/canister_sandbox && chmod +x /usr/bin/canister_sandbox && rm canister_sandbox.gz

ARG SANDBOX_LAUNCHER_REF='ec35ebd252d4ffb151d2cfceba3a86c4fb87c6d6'
ADD ${DFINITY_ARTIFACTS_URL}/ic/${SANDBOX_LAUNCHER_REF}/release/sandbox_launcher.gz .
RUN zcat sandbox_launcher.gz > /usr/bin/sandbox_launcher && chmod +x /usr/bin/sandbox_launcher && rm sandbox_launcher.gz

EXPOSE 8080 4100 9090 2497

# Add Tini (equivalent to passing --init to `docker run` in the Docker CLI which is, however, not available in the Rust Docker library)
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

ENTRYPOINT ["/tini", "--", "replica"]
