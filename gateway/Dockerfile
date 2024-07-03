FROM --platform=linux/amd64 ubuntu:24.04

RUN apt update && apt install -y ca-certificates curl

# replica version

ARG IC_COMMIT

# binaries

ARG DFINITY_ARTIFACTS_URL='https://dfinity-download-public.s3.eu-central-1.amazonaws.com'

ADD ${DFINITY_ARTIFACTS_URL}/ic/${IC_COMMIT}/release/pocket-ic.gz .
RUN zcat pocket-ic.gz > /usr/local/bin/pocket-ic && chmod +x /usr/local/bin/pocket-ic && rm pocket-ic.gz

# scripts

COPY ./gateway.sh /usr/local/bin/gateway.sh

EXPOSE 8000

ENTRYPOINT [ "/usr/local/bin/gateway.sh" ]
