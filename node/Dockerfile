FROM --platform=linux/amd64 ubuntu:24.04

COPY --from=docker:dind /usr/local/bin/docker /usr/local/bin/

RUN apt update && apt install -y ca-certificates jq libunwind-dev

# Replica version

ARG IC_COMMIT

# Binaries

ARG DFINITY_ARTIFACTS_URL='https://dfinity-download-public.s3.eu-central-1.amazonaws.com'

ADD ${DFINITY_ARTIFACTS_URL}/ic/${IC_COMMIT}/release/replica.gz .
RUN zcat replica.gz > /usr/local/bin/replica && chmod +x /usr/local/bin/replica && rm replica.gz

ADD ${DFINITY_ARTIFACTS_URL}/ic/${IC_COMMIT}/release/ic-https-outcalls-adapter.gz .
RUN zcat ic-https-outcalls-adapter.gz > /usr/local/bin/ic-https-outcalls-adapter && chmod +x /usr/local/bin/ic-https-outcalls-adapter && rm ic-https-outcalls-adapter.gz

ADD ${DFINITY_ARTIFACTS_URL}/ic/${IC_COMMIT}/release/canister_sandbox.gz .
RUN zcat canister_sandbox.gz > /usr/local/bin/canister_sandbox && chmod +x /usr/local/bin/canister_sandbox && rm canister_sandbox.gz

ADD ${DFINITY_ARTIFACTS_URL}/ic/${IC_COMMIT}/release/sandbox_launcher.gz .
RUN zcat sandbox_launcher.gz > /usr/local/bin/sandbox_launcher && chmod +x /usr/local/bin/sandbox_launcher && rm sandbox_launcher.gz

ADD ${DFINITY_ARTIFACTS_URL}/ic/${IC_COMMIT}/release/orchestrator.gz .
RUN zcat orchestrator.gz > /usr/local/bin/orchestrator && chmod +x /usr/local/bin/orchestrator && rm orchestrator.gz

# Scripts

COPY ./manageboot.sh /usr/local/bin/manageboot.sh
COPY ./node.sh /usr/local/bin/node.sh

EXPOSE 8080 4100 9090 2497

ENTRYPOINT ["/usr/local/bin/node.sh"]
