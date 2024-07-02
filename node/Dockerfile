FROM --platform=linux/amd64 ubuntu:24.04

COPY --from=docker:dind /usr/local/bin/docker /usr/local/bin/

RUN apt update && apt install -y ca-certificates jq libunwind-dev

# Replica version

ARG IC_COMMIT='b9a0f18dd5d6019e3241f205de797bca0d9cc3f8'

# Binaries

ARG DFINITY_ARTIFACTS_URL='https://dfinity-download-public.s3.eu-central-1.amazonaws.com'

ADD ${DFINITY_ARTIFACTS_URL}/ic/${IC_COMMIT}/release/replica.gz .
RUN zcat replica.gz > /usr/bin/replica && chmod +x /usr/bin/replica && rm replica.gz

ADD ${DFINITY_ARTIFACTS_URL}/ic/${IC_COMMIT}/release/ic-https-outcalls-adapter.gz .
RUN zcat ic-https-outcalls-adapter.gz > /usr/bin/ic-https-outcalls-adapter && chmod +x /usr/bin/ic-https-outcalls-adapter && rm ic-https-outcalls-adapter.gz

ADD ${DFINITY_ARTIFACTS_URL}/ic/${IC_COMMIT}/release/canister_sandbox.gz .
RUN zcat canister_sandbox.gz > /usr/bin/canister_sandbox && chmod +x /usr/bin/canister_sandbox && rm canister_sandbox.gz

ADD ${DFINITY_ARTIFACTS_URL}/ic/${IC_COMMIT}/release/sandbox_launcher.gz .
RUN zcat sandbox_launcher.gz > /usr/bin/sandbox_launcher && chmod +x /usr/bin/sandbox_launcher && rm sandbox_launcher.gz

ADD ${DFINITY_ARTIFACTS_URL}/ic/${IC_COMMIT}/release/orchestrator.gz .
RUN zcat orchestrator.gz > /usr/bin/orchestrator && chmod +x /usr/bin/orchestrator && rm orchestrator.gz

# Scripts

COPY ./node.sh /usr/bin/node.sh

EXPOSE 8080 4100 9090 2497

ENTRYPOINT ["/usr/bin/node.sh"]
